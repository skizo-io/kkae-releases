# Kkae

A small macOS menu-bar utility that keeps your Mac awake while you work.

**macOS 13 or newer · Apple Silicon and Intel · Developer ID signed and Apple notarized.**

## Install with one command

If Kkae is running, choose **Quit** from its menu before running the installer. Your saved settings are kept.

```bash
curl -fsSL https://raw.githubusercontent.com/skizo-io/kkae-releases/main/install.sh | bash
```

The installer checks the pinned SHA-256, Developer ID signature and Gatekeeper before installing into `~/Applications/Kkae.app`. No administrator password or developer tools are required. It never disables Gatekeeper, clears quarantine or deletes your preferences. Existing Kkae installations are backed up before replacement.

Prefer a disk image? Download the DMG from [Releases](https://github.com/skizo-io/kkae-releases/releases/latest), open it, and drag Kkae into Applications. Do not install both copies.

## AI mode

The bar and panel cycle through **Off → AI → Timer → Always**. AI mode keeps the Mac awake while a connected local agent is working and releases sleep prevention when its work ends. Opening an AI app alone is not treated as activity.

Connect the agent's lifecycle hooks once for the project you use. The following commands print a configuration fragment; they do not install or overwrite anything:

```bash
~/Applications/Kkae.app/Contents/MacOS/Kkae --agent-hooks --source codex
~/Applications/Kkae.app/Contents/MacOS/Kkae --agent-hooks --source claude
```

Use the first fragment in your project's `.codex/hooks.json`, or the second in `.claude/settings.local.json`. Merge with existing hooks rather than replacing them. In Codex, trust your project and review the new hooks with `/hooks`. Use `/Applications/Kkae.app` instead if that is where you installed it.

Local Codex CLI start/end delivery is verified. Claude Code support is implemented from its documented hooks; real Claude CLI/Desktop Code testing is pending. General Claude Chat, Cowork, cloud and SSH jobs are not covered. Missing completion information can show **AI · Waiting**; you can always choose Off. A lost completion signal cannot keep a registered job active beyond 12 hours.

Choose `Kkae-<version>.dmg` or use the command above. GitHub's automatic **Source code** archives contain only this public repository's installation script and guide, not the private Kkae application source.

To verify the download without installing or launching:

```bash
curl -fsSL https://raw.githubusercontent.com/skizo-io/kkae-releases/main/install.sh | bash -s -- --check
```

## Use

- Open Kkae and look for the coffee cup in the menu bar. A new installation starts Off; when no duration has been chosen, starting a timer uses one hour. Your last selected duration is reused afterwards.
- Click the menu-bar item for controls. The left 10% of the bar selects Off, the right 10% selects Always, and the middle selects 5 minutes–12 hours in five-minute steps. The two marks align with 5 minutes and 12 hours. Drag vertically away for finer adjustment.
- Click the time/mode button to cycle **Timer → Always → Off**. Timer stops at expiry; Always keeps the Mac awake until you turn it off. Off releases sleep prevention.
- **Keep Display On** also prevents display sleep. With it off, the display may sleep while your Mac keeps working.
- **Turn Off on Battery** stops sleep prevention when running on battery; reconnecting the charger does not restart it. It is on by default.
- **Launch at Login** registers Kkae with macOS only if you enable it. macOS may require approval in System Settings.
- **Show Panel** shows a small floating panel. Drag the dotted handle to move it; click the time/mode text to change mode. The handle does not respond to clicks.
- **Quit** exits the app and releases its power requests.
- **Show Tips** shows explanations below the settings in Korean, English or Japanese, following your Mac language. It is on by default.
- **Contact** (문의하기 / お問い合わせ, following your Mac language) opens the SBOX inquiry form. The window title follows the same language. Nothing is sent until you press Send.

Kkae prevents idle system sleep, with display prevention optional. It does **not** bypass lid-close sleep, manual sleep or battery safety limits. Display prevention can affect display-triggered locking: lock your screen yourself when leaving the Mac, and follow your employer's policies.

## Update and uninstall

Quit Kkae and run the same install command again. Previous command-installed apps are preserved under `~/Library/Application Support/Kkae/Install Backups`; preferences are not reset. To uninstall, quit the app and move Kkae.app to Trash.

## Privacy and source

Kkae is operated from Japan. No accounts, ads or analytics SDK. Preferences stay on your Mac. The production app creates and retains an app-specific random installation ID locally. On a day of use, it sends that ID, service, platform, production channel and UTC date at most once through SBOX Supabase in Singapore to Google Analytics. Input, timer settings, AI task status, inquiry content, account/device/advertising IDs are excluded. The ID is not joined with other apps or personal data.

Counts deduplicate repeated use of an installation for service operation and improvement; they are not exact people. Additional Google sharing is disabled and advertising use is denied. Original IP and User-Agent are not forwarded to Analytics; network providers may process ordinary connection/security logs. Retention/deletion follow Google Analytics settings and policies. Existing saved collection refusals are preserved; failed requests are not retried that day. Deleting the local ID does not immediately delete server data. For collection-stop or deletion requests, contact skizo80@gmail.com. The installer downloads from GitHub and macOS may contact Apple to verify software trust.

If you choose Contact and Send, SBOX receives your message, optional email, service/app version and build, platform, language and a random receipt ID. Do not include passwords or private files. Inquiry processing uses the existing SBOX Supabase project in Singapore. The inquiry database stores an HMAC of the connection IP for abuse prevention, not the raw IP; infrastructure providers may process connection logs under their own terms. The retention target is 60 days; cleanup is manual, not automatic, so records may remain beyond 60 days until removed. To request deletion, contact skizo80@gmail.com. Message/email fields remain only in memory in the app until successful submission or quitting; they are not sent as logs.

Disable Launch at Login before uninstalling if you enabled it.

This public repository contains installation instructions and the installer script only. Application source code is kept private. No certificates, private keys or credentials are distributed. Apple notarization is a security check, not an endorsement of the app.

Support: [open an issue](https://github.com/skizo-io/kkae-releases/issues).
