# Release Build Guide — WeCare

Play Store ke liye **signed AAB / APK** GitHub Actions se banane ka tarika.

| | |
|---|---|
| App ID | `com.wecare.newapp` |
| Workflow | `.github/workflows/release.yml` |
| Signing config | `android/app/build.gradle.kts` (line 15–20, 57–91) |
| Credentials | `android/key.properties` (repo me committed) |

---

## ⬇️ Latest build — ready to upload

**[Build #4 — v1.0.9 (versionCode 9)](https://github.com/Mr-argha-das/wecare-app/releases/tag/build-4)**

| File | Size | Kya karein |
|---|---|---|
| [`wecare-1.0.9-9-run4.aab`](https://github.com/Mr-argha-das/wecare-app/releases/download/build-4/wecare-1.0.9-9-run4.aab) | 59 MB | **Play Console me upload karein** |
| [`wecare-1.0.9-9-run4.apk`](https://github.com/Mr-argha-das/wecare-app/releases/download/build-4/wecare-1.0.9-9-run4.apk) | 62 MB | Phone me direct install / testing |

### Signature verified ✅

Build ke baad CI ne AAB ke andar se **asli signer certificate** nikaal kar
keystore ke certificate se fingerprint compare kiya (poora output: `signing-report.txt`):

```
KEYSTORE expected : 13:D4:23:18:72:59:F5:5A:9B:62:21:DA:4E:19:7E:57:
                    CE:2C:C0:E5:29:2F:B8:43:E5:14:05:57:3D:15:2D:00
AAB signer        : (same)                                    -> MATCH
APK V2 signer     : (same)                                    -> MATCH
owner             : CN=Das, OU=das, O=das, L=Jaipur, ST=Rajsthan, C=91
FINAL: PASS
```

> Ye check isliye zaroori hai kyunki `build.gradle.kts` (line 83–85) credentials
> na milne par chupchap **debug key** par chala jaata hai, aur uska pata Play
> Console par upload karte waqt chalta ("signed with a debug certificate").
> Ab aisa hua to CI build hi fail kar dega.

### ⚠️ Upload se pehle: versionCode check karein

Is build me **versionCode = 9** hai (`pubspec.yaml` ka `version: 1.0.9+9`).
Play Store har naye upload ke liye **pichhle se bada** versionCode maangta hai.

Agar versionCode 9 pehle hi publish ho chuka hai, to naya build banayein —
`build_number` input me `10` dein (neeche "Agli build" dekhein), ya `pubspec.yaml`
me version `1.0.10+10` kar dein.

---

## 🔴 Security — abhi ki sthiti

Repo **public** hai aur usme dono cheezein maujood hain:

- `upload-keystore.jks` (signing key)
- `android/key.properties` (uska password, plaintext)

Matlab **koi bhi aapki upload key use kar sakta hai.** Git history permanent
hoti hai — file delete karne ya password badalne se ye theek nahi hota, kyunki
purani file aur purana password history me rehte hain.

### Achhi khabar: ye recoverable hai

Aapki app Play Store par live hai, yaani **Play App Signing** on hai. Iska matlab
ye keystore sirf **upload key** hai — asli *app signing key* Google ke paas hai
aur wo kabhi expose nahi hui. Users ko jaane wali app abhi bhi surakshit hai.

### Karne layak kaam (priority order)

**1. Upload key reset karwayein** — Play Console → **Setup** → **App integrity**
→ *App signing* → **Request upload key reset**. Nayi key banayein:

```bash
keytool -genkeypair -v -keystore upload-keystore-new.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Google ko bhejne ke liye certificate export karein
keytool -export -rfc -keystore upload-keystore-new.jks \
  -alias upload -file upload_certificate.pem
```

Google 1–2 din me key badal deta hai. Nayi key **kabhi** repo me commit na karein.

**2. Repo private kar dein** — Settings → Danger Zone → Change visibility.
Isse aage ka exposure ruk jaata hai.

**3. Secrets wale setup par shift karein** — neeche *"Safe setup"* dekhein.

**4. Naya password mazboot rakhein.** Purana `14322005` 8 digit ka tha. Maine
is keystore par brute-force speed naapi thi: 1 GPU par ~5 minute. Nayi key ke
liye lamba random passphrase use karein.

---

## Agli build kaise banayein

### Abhi (ye PR merge hone se pehle)

Is branch par koi bhi commit push karte hi build chal jaata hai
(`push: branches: [arena/01a10c30-wecare-app]` trigger).

### PR merge hone ke baad (recommended)

GitHub → **Actions** → **Release Build (signed AAB + APK)** → **Run workflow**

| Input | Default | Kaam |
|---|---|---|
| `artifact` | `both` | `aab`, `apk`, ya dono |
| `key_alias` | *(khali)* | khali = auto-detect |
| `build_name` | *(khali)* | versionName override, jaise `1.0.10` |
| `build_number` | *(khali)* | **versionCode override, jaise `10`** |

> `workflow_dispatch` ka "Run workflow" button tabhi dikhta hai jab workflow
> file **main** branch par ho — isliye pehle PR merge karein.

### Tag se

```bash
git tag v1.0.10 && git push origin v1.0.10
```

Build chalega aur files us tag ki GitHub Release me attach ho jayengi.

---

## Workflow kaise kaam karta hai

Workflow **do modes** support karta hai aur khud detect kar leta hai:

| Mode | Kab | Credentials kahan se |
|---|---|---|
| `repo` | `android/key.properties` repo me ho | wahi file *(abhi yahi active hai)* |
| `secret` | key.properties na ho | GitHub Secrets |

Steps:

1. Signing mode detect
2. Keystore + password + alias validate (galat hua to Gradle ke cryptic error
   se pehle saaf message milta hai)
3. `flutter build appbundle --release` / `flutter build apk --release`
4. **Signature verify** — AAB/APK ke signer cert ka SHA-256 keystore se compare;
   debug key mili to build **fail**
5. Artifacts upload + GitHub Release publish
6. Runner se credentials delete

---

## Safe setup (secrets) par shift kaise karein

```bash
# 1. keystore ka base64 banayein
base64 -w0 upload-keystore.jks          # Linux
base64 -i upload-keystore.jks | pbcopy  # macOS
```

2. GitHub → Settings → Secrets and variables → Actions me add karein:

| Secret | Value |
|---|---|
| `KEYSTORE_BASE64` | upar wala base64 |
| `KEYSTORE_PASSWORD` | store password |
| `KEY_PASSWORD` | *(optional — blank = store password)* |
| `KEY_ALIAS` | *(optional — blank = auto-detect)* |

3. Repo se credentials hatayein:

```bash
git rm --cached android/key.properties upload-keystore.jks
git commit -m "Move signing credentials to GitHub Secrets"
git push
```

Workflow apne aap `secret` mode par switch ho jayega — koi aur badlav nahi chahiye.

---

## Local machine par release build

```bash
cp android/key.properties.example android/key.properties
# apni values bharein, phir:
flutter build appbundle --release
```

---

## Firebase SHA fingerprint

App `firebase_core` + `firebase_messaging` use karti hai — in dono ke liye SHA
fingerprint **zaroori nahi**. Lekin aage Firebase **Auth** (Google/Phone sign-in)
ya **Dynamic Links** add karein to ye SHA-1 Firebase Console me daalna hoga:

```
EE:D5:10:8A:5F:25:78:66:E4:D1:A1:38:4B:8C:FE:E4:86:DD:A2:93
```

Firebase Console → Project settings → Your apps → `com.wecare.newapp` → Add fingerprint.

> Play App Signing on hai, isliye Play Console (Setup → App integrity) wale
> **app signing key** ka SHA-1 bhi add karein — users tak jaane wali app us key
> se sign hoti hai.

---

## Troubleshooting

| Error | Wajah / Fix |
|---|---|
| `Signing credentials nahi mile` | Na `android/key.properties` hai, na `KEYSTORE_PASSWORD` secret |
| `Keystore khul nahi rahi` | `storePassword` galat, ya `KEYSTORE_BASE64` adhoora paste hua |
| `Keystore file nahi mili` | `storeFile` path galat. Relative path **`android/app/`** se resolve hota hai — repo root ki file ke liye `../../upload-keystore.jks` |
| `Alias nahi mila` | Log me alias list print hoti hai, usme se chunein (ya khali chhod dein) |
| `AAB debug key se signed hai` | key.properties load nahi hui — "Detect signing mode" step ka log dekhein |
| Play: `versionCode N already used` | `build_number` input me bada number dein |
| Play: `signed with a debug certificate` | Aapne `Build APK (test build)` workflow chalaya hai — `Release Build` wala chalayein |
