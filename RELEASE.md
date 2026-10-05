# Release Build Guide — WeCare

Play Store ke liye **signed AAB / APK** GitHub Actions se banane ka tarika.

| | |
|---|---|
| App ID | `com.wecare.newapp` |
| Workflow | `.github/workflows/release.yml` |
| Gradle signing config | `android/app/build.gradle.kts` (line 15–20, 57–91) |

---

## 🔴 Pehle ye padhein — Security

Ye repo **public** hai aur `upload-keystore.jks` seedhe repo me commit ho chuki hai.
Matlab duniya me koi bhi use download kar sakta hai:
`https://github.com/Mr-argha-das/wecare-app/blob/main/upload-keystore.jks`

Keystore password-protected hai, isliye turant koi app sign nahi kar sakta —
**lekin** password offline brute-force kiya ja sakta hai. Keystore leak hone ka
matlab hai koi aur aapke naam se app sign kar sakta hai, aur keystore badalne par
Play Store par aapki app ka update **kabhi** nahi chadhega.

**Teen options, behtar se kam behtar:**

| Option | Kya karna hai |
|---|---|
| ✅ **Best** | Repo **private** karein (Settings → General → Danger Zone → Change visibility) |
| ✅ **Best** | `.jks` repo se hatayein aur `KEYSTORE_BASE64` secret use karein ([neeche](#option-b-keystore-secret-me-recommended)) |
| ⚠️ Agar key already leak maan rahe hain | Play Console → Setup → App integrity → **Request upload key reset** |

Workflow dono tarike support karta hai, isliye `.jks` repo se hataane ke baad bhi
build bina kisi badlav ke chalta rahega.

---

## 1. Secrets add karein

GitHub → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

| Secret | Zaroori? | Value |
|---|---|---|
| `KEYSTORE_PASSWORD` | ✅ Haan | Keystore (store) ka password |
| `KEY_PASSWORD` | ❌ Optional | Key ka password. Na dein to store password hi use hoga |
| `KEY_ALIAS` | ❌ Optional | Alias. Na dein to keystore se **auto-detect** ho jayega |
| `KEYSTORE_BASE64` | ❌ Optional | Keystore ka base64 — isse `.jks` repo me rakhne ki zaroorat nahi |

> Alias yaad nahi? Koi baat nahi — khali chhod dein. Workflow keystore kholkar
> saare alias print karta hai aur pehla wala use kar leta hai.

### Option B: Keystore secret me (recommended)

Apne laptop par:

```bash
# macOS
base64 -i upload-keystore.jks | pbcopy

# Linux
base64 -w0 upload-keystore.jks | xclip -selection clipboard

# Windows (PowerShell)
[convert]::ToBase64String((Get-Content upload-keystore.jks -AsByteStream)) | Set-Clipboard
```

Output ko `KEYSTORE_BASE64` secret me paste karein. Phir repo se file hata dein:

```bash
git rm --cached upload-keystore.jks
git commit -m "Remove keystore from repo; use KEYSTORE_BASE64 secret"
git push
```

> Isse file aage se commit nahi hogi, par **purani history me rahegi**.
> Poori tarah mitane ke liye `git filter-repo` ya BFG chahiye — ya repo private kar dein.

---

## 2. Build chalayein

GitHub → **Actions** → **Release Build (signed AAB + APK)** → **Run workflow**

| Input | Default | Kaam |
|---|---|---|
| `artifact` | `both` | `aab` (Play Store), `apk` (direct install), ya dono |
| `key_alias` | *(khali)* | Khali = auto-detect |
| `build_name` | *(khali)* | versionName override, jaise `1.0.10` |
| `build_number` | *(khali)* | versionCode override, jaise `10` |

Khali chhodne par `pubspec.yaml` ki version use hoti hai — abhi **`1.0.9+9`**
(versionName `1.0.9`, versionCode `9`).

> **Play Store rule:** har naye upload ka `versionCode` pichhle se **bada** hona chahiye.
> Agar versionCode 9 pehle hi upload ho chuka hai, `build_number` me `10` daalein
> (ya `pubspec.yaml` me version badha dein).

Build khatm hone par run page ke **Artifacts** section se download karein:

```
wecare-1.0.9-9-run3.aab   ← Play Console me upload karein
wecare-1.0.9-9-run3.apk   ← phone me direct install
```

### Tag se build (optional)

```bash
git tag v1.0.9
git push origin v1.0.9
```

Isse build apne aap chalega aur files ek **GitHub Release** me attach ho jayengi
(artifacts 30 din me expire hote hain, release files nahi).

---

## 3. Workflow kya-kya karta hai

1. `KEYSTORE_PASSWORD` set hai ya nahi — check
2. Keystore laata hai: `KEYSTORE_BASE64` secret **ya** repo ki `upload-keystore.jks`
   (file `$RUNNER_TEMP` me rakhi jaati hai — workspace se bahar, taaki kisi artifact me pack na ho)
3. Keystore kholta hai, alias detect karta hai, **SHA-1 / SHA-256 fingerprint print** karta hai
4. `android/key.properties` generate karta hai (absolute `storeFile` path ke saath)
5. `flutter build appbundle --release` / `flutter build apk --release`
6. **Signature verify** — agar build DEBUG key se signed nikla to build **fail** kar deta hai
7. Artifacts upload, phir `key.properties` + keystore runner se delete

> Step 6 isliye hai kyunki `build.gradle.kts` (line 83–85) `key.properties` na milne par
> chupchap debug key par chala jaata hai. Us silent failure ka pata Play Console par upload
> karte waqt chalta — ab CI me hi pakda jayega.

---

## 4. Local machine par release build

```bash
cp android/key.properties.example android/key.properties
# apni values bharein, phir:
flutter build appbundle --release
```

`android/key.properties` gitignored hai — commit nahi hogi.

---

## 5. Firebase SHA fingerprint (agar zaroorat pade)

App `firebase_core` + `firebase_messaging` use karti hai. In dono ke liye SHA
fingerprint zaroori **nahi** hai. Lekin aage kabhi Firebase **Auth** (Google /
Phone sign-in) ya **Dynamic Links** add karein, to release key ka SHA-1 Firebase
Console me daalna hoga.

SHA-1 har release build ke log me **"Inspect keystore and resolve alias"** step me print hota hai.
Firebase Console → Project settings → Your apps → `com.wecare.newapp` → **Add fingerprint**.

> Play App Signing on hai to Play Console (Setup → App integrity) wala
> **app signing key** ka SHA-1 bhi add karna hoga, kyunki users tak jaane wali app
> us key se sign hoti hai.

---

## Troubleshooting

| Error | Wajah / Fix |
|---|---|
| `Secret 'KEYSTORE_PASSWORD' set nahi hai` | Step 1 karein |
| `Keystore khul nahi rahi` | `KEYSTORE_PASSWORD` galat hai, ya `KEYSTORE_BASE64` adhoora paste hua |
| `Alias '...' is keystore me nahi hai` | Log me print hui list me se alias chunein, ya `key_alias` khali chhod dein |
| `AAB DEBUG key se signed hai` | `key.properties` load nahi hui — workflow log me "Create android/key.properties" step dekhein |
| Play Console: `versionCode N already used` | `build_number` input me bada number dein |
| Play Console: `signed with a debug certificate` | Aapne `Build APK (test build)` workflow chalaya hai. `Release Build` wala chalayein |
