# Face Attendance — Nurse Dashboard

Nurse dashboard me **face-based attendance** add kar diya gaya hai.
Backend me **koi change nahi** kiya gaya — jo APIs already live hain, app unhi ko call karta hai.

---

## 1. Kya-kya bana

### Dashboard card (`Attendance`)
- Aaj ka **Punch In** aur **Punch Out** time.
- State chip: **Not punched in** / **On duty** / **Completed**.
- **Punch In** (hara) — sirf tab enabled jab `today.can_punch_in == true`.
- **Punch Out** (laal) — sirf tab enabled jab `today.can_punch_out == true`.
- `enrolled == false` ho to amber banner **"Face enroll karein"** aur dono punch buttons **disabled**.
- Neeche **History** aur **Face** ke shortcuts.
- App background se wapas aate hi status **apne aap refresh** ho jaata hai.
- Dashboard ka pull-to-refresh card ko bhi refresh karta hai.

### Punch flow (ek tap me)
```
tap → camera permission → guide (oval + tips) → FRONT camera
    → photo → oval preview (Retake / Use photo)
    → GPS location → POST /nurse/face/punch
    → success snackbar: "Punch In successful - 09:14 AM (38 m door)"
    → card refresh
```
Fail hone par snackbar me backend ka message + **Retry** button. Koi offline queue nahi hai (spec ke mutabik).

### Face Enroll screen
- 6 photos, 6 alag pose: **Seedha / Left / Right / Upar / Neeche / Smile**.
- 3×2 grid, har slot tap karke dobara photo li ja sakti hai.
- Progress bar `n / 6`.
- Sab 6 ho jaane par **Save & Enroll** → `POST /nurse/face/enroll`.
- Pehle se enrolled ho to green banner + **Delete** (→ `DELETE /nurse/face/enroll`) se re-enroll.

### History screen
- Default **current month**.
- Month selector (`‹ October 2026 ›`) — future month par jaana **block** hai.
- Summary: Present / Half / Absent.
- Day-wise list: date, in/out time, worked hours, status chip.
- Pull-to-refresh + empty state + error state with Retry.

### Purana attendance screen
Delete **nahi** kiya gaya. `My Attendance` ab 2 tabs me hai:

| Tab | Kya hai | API |
|---|---|---|
| **Face Attendance** | naya card + is mahine ka record | `/nurse/face/*` |
| **Monthly** | purana calendar view, jaisa tha waisa | `/nurse/attendance?month=` |

---

## 2. API contract (jo app bhejta hai)

| Method | Path | Request | Response |
|---|---|---|---|
| `GET` | `/nurse/face/status` | — | `enrolled`, `images`, `today{...}` |
| `POST` | `/nurse/face/enroll` | `{"images": [6 × data-uri]}` | `{"message": "..."}` |
| `DELETE` | `/nurse/face/enroll` | `{}` | — |
| `POST` | `/nurse/face/punch` | `{"image", "type", "latitude", "longitude", "accuracy"}` | `{"time", "distance", "message"}` |
| `GET` | `/nurse/face/history?month=YYYY-MM` | — | `{"days":[...], "summary":{...}}` |

**Image format:** `"data:image/jpeg;base64,<...>"`, long side ≤ **720 px**, JPEG **q80** → normally **60–130 KB** (limit 250 KB).
Resize/compress `image_picker` native side par karta hai (`maxWidth/maxHeight: 720`, `imageQuality: 80`) — koi extra library nahi.

**Errors:** `ApiClient._handleError` pehle `body["detail"]` uthata hai, phir `body["message"]`.
Backend ka Hindi message **jaisa hai waisa hi** snackbar me dikhta hai. 401 par auto-logout pehle se tha.

**Timestamps:** backend IST bhejta hai → `IstTime` class device ke **local time** me convert karke `hh:mm a` format me dikhati hai. Agar string me timezone ho to wahi honour hoti hai.

**Key-name tolerance:** models `punch_in_time` / `punch_in` / `in_time` / `check_in` jaise kai spellings accept karte hain, aur `data` / `result` wrapper bhi handle karte hain. Isliye backend ki exact naming thodi alag ho to bhi app crash nahi karega — value bas blank dikhegi.

---

## 3. Security

- Base64 image **kabhi log nahi hoti**. Iske liye naya `ApiClient.postNoLog()` banaya gaya jo sirf `POST <path> -> <status>` print karta hai — na request body, na response body.
- Token pehle bhi log nahi hota tha, ab bhi nahi hota.
- Photos phone me save nahi hoti — sirf memory me rehti hain aur upload ke baad chali jaati hain.

---

## 4. Files

### Naye (8)
| File | Kya hai |
|---|---|
| `lib/features/attendance/attendance_models.dart` | `AttendanceStatus`, `AttendanceToday`, `PunchResult`, `AttendanceDay`, `AttendanceSummary`, `IstTime` |
| `lib/features/attendance/attendance_api.dart` | 5 API calls + `apiErrorText()` |
| `lib/features/attendance/face_capture.dart` | front camera + oval guide/preview, data-uri banata hai |
| `lib/features/attendance/punch_service.dart` | poora punch flow: photo → GPS → POST |
| `lib/features/attendance/attendance_card.dart` | dashboard ka Attendance card |
| `lib/features/attendance/face_enroll_page.dart` | 6-photo enroll screen |
| `lib/features/attendance/face_history_page.dart` | history screen + embeddable view |
| `lib/features/attendance/nurse_attendance_page.dart` | 2-tab wrapper (Face / Monthly) |

### Badle gaye (7)
| File | Change |
|---|---|
| `lib/core/network/api_client.dart` | `postNoLog()` add |
| `lib/features/duty/dashboard_page.dart` | Attendance card + refresh tick |
| `lib/features/duty/action_cards_section.dart` | import naye tab page par |
| `lib/features/duty/attendance.dart` | class rename → `MonthlyAttendanceTab`, AppBar hata (ab tab me hai) |
| `ios/Runner/Info.plist` | `NSCameraUsageDescription` face attendance ke liye reword |
| `pubspec.yaml` | `1.1.0+10` → `1.2.0+11` |
| `.github/workflows/release.yml` | branch filter + `flutter analyze` report |

### Dependencies
**Zero naye packages.** `image_picker`, `geolocator`, `permission_handler`, `intl` sab pehle se pubspec me the.
Android `CAMERA` + `ACCESS_FINE_LOCATION` manifest me pehle se declared hain.

---

## 5. Test checklist (12 items)

> ⚠️ Niche wale test **device par** chalane padenge — live backend, asli nurse account, GPS aur test #6 ke liye kisi doosre insaan ka chehra chahiye. Main sandbox se ye nahi chala sakta (na emulator hai, na backend reachable). Code-level jo verify ho sakta tha wo column 3 me hai.

| # | Test | Code-level | Device par |
|---|---|---|---|
| 1 | Dashboard par Attendance card dikhta hai, aaj ka In/Out time + sahi state | ✅ | ☐ |
| 2 | `enrolled == false` → "Face enroll karein" banner, dono punch buttons disabled | ✅ | ☐ |
| 3 | Face Enroll me 6 photos li ja sakti hain, progress `6/6` par Save enable hota hai | ✅ | ☐ |
| 4 | Enroll success ke baad card refresh hota hai aur punch buttons enable ho jaate hain | ✅ | ☐ |
| 5 | Punch In tap → front camera khulta hai → photo → GPS → success snackbar with time | ✅ | ☐ |
| 6 | **Doosre insaan ka chehra** → backend reject → `detail` ka Hindi message jaisa ka waisa dikhe | ✅ | ☐ |
| 7 | Punch In ke baad state "On duty", Punch In disabled, Punch Out enabled | ✅ | ☐ |
| 8 | Punch Out → success (time + distance) → state "Completed", dono buttons disabled | ✅ | ☐ |
| 9 | History screen current month default par khulti hai, records sahi dikhte hain | ✅ | ☐ |
| 10 | Month ‹ › chalta hai, future month par next button disabled | ✅ | ☐ |
| 11 | Camera permission deny → saaf message + Settings link; GPS off → "GPS on karein" | ✅ | ☐ |
| 12 | App background → foreground par card auto-refresh; pull-to-refresh bhi kaam kare | ✅ | ☐ |

**Code-level ✅ ka matlab:** logic likha hua hai, `flutter analyze` me koi error nahi, aur CI me release build successfully compile + sign hui hai. **Runtime behaviour live backend ke saath verify karna baaki hai.**

### Network / error cases
| Case | Expected |
|---|---|
| Internet band | "Internet connection check karein..." + Retry |
| Server timeout | "Server se jawab nahi mila." + Retry |
| 401 | auto-logout → login screen (pehle se tha) |
| GPS 25s me na mile | last known location, warna saaf message |
| Photo cancel | kuch nahi hota, koi API call nahi |

---

## 6. Jo spec se alag hai (1 cheez)

**Live camera preview ke andar oval overlay nahi hai.**

Uske liye `camera` package chahiye tha. Maine wo **jaanbujh kar nahi** liya, kyunki:
- `android/app/build.gradle.kts` me `force("androidx.core:core:1.13.1")` likha hai — CameraX isse naya core maangta hai, aur ye **runtime crash** de sakta tha jise main sandbox se test nahi kar sakta.
- `camera_android_camerax` ko `minSdk 24` chahiye — minSdk badalna padta.
- Naya native plugin = build fail hone ka risk, aur aapko **chalta hua app** chahiye.

Uske badle:
- Camera kholne se **pehle** oval guide + 3 tips (roshni / chehra beech me / mask hatayein) wala sheet aata hai.
- Photo lene ke **baad** oval frame me preview + **Retake / Use photo**.
- Front camera direct pre-selected hota hai (`preferredCameraDevice: front`).

Agar aapko bilkul live oval preview hi chahiye, bol dijiye — `camera` package ke saath alag se kar denge aur usi run me gradle conflict bhi fix kar denge.

**Screen recording** main nahi bana sakta — sandbox me na emulator hai na screen capture. Device par chala kar aap khud record kar sakte hain.
