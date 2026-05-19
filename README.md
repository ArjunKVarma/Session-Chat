# Sessions — Private Secure Chat Rooms

Sessions is a premium, real-time anonymous messaging application built with Flutter and Firebase. Designed around a **Zero-Knowledge Architecture**, Sessions prioritizes user privacy and security above all else. Users can create or join temporary secure rooms using a unique combination of three English words and a password, ensuring complete anonymity with no personal identification, phone numbers, or metadata trace.



## 🔒 Security & Privacy Core

Sessions employs a state-of-the-art security suite to ensure conversations remain strictly confidential:

* **Zero-Knowledge Architecture:** No real identities, phone numbers, or email sign-ups are required. Room keys and passwords are never transmitted or stored in plain text.
* **End-to-End (E2E) Encryption:** Messages and shared images are encrypted client-side using the AES-256 algorithm via the `encrypt` package.
* **Derived Cryptographic Keys:** Decryption keys are derived dynamically on the user's device using a cryptographic combination of the room's three-word ID and password. Firebase never has access to the keys or the plaintext message content.
* **SHA-256 Room Hashing:** Room identifiers are hashed client-side with SHA-256 before interacting with the Firebase backend. The server only sees anonymous hashes, meaning database admins cannot know the names of active rooms.
* **Ephemeral "No Traces" Rooms:** Upon session deletion, all message logs, files, and room associations are immediately and permanently wiped from both local devices and Firebase servers.

---

## 📐 System Architecture

Sessions uses a decentralized, client-side cryptographic flow to ensure no plaintext information ever leaves the user's device:

```mermaid
graph TD
    classDef client fill:#1f2937,stroke:#3b82f6,stroke-width:2px,color:#f3f4f6;
    classDef server fill:#111827,stroke:#ef4444,stroke-width:2px,color:#f3f4f6;
    classDef crypto fill:#0f172a,stroke:#10b981,stroke-width:2px,color:#f3f4f6;

    subgraph ClientA["Client A (Sender)"]
        A_Input["User Input:<br/>Room ID & Password"]:::client
        A_KeyDerive["AES-256 Key Derivation<br/>(Client-Side PBKDF2/SHA-256)"]:::crypto
        A_RoomHash["SHA-256 Room Hashing<br/>(Client-Side)"]:::crypto
        A_MsgPlain["Plaintext Message / Media"]:::client
        A_Encrypt["Client-Side AES Encryption"]:::crypto
        A_MsgCipher["Encrypted Ciphertext"]:::client
    end

    subgraph Firebase["Firebase Firestore (Zero-Knowledge Cloud)"]
        F_Rooms["Hashed Rooms Registry<br/>(Firebase only sees anonymous hashes)"]:::server
        F_Messages["Encrypted Messages Stream<br/>(No decryptable data stored)"]:::server
    end

    subgraph ClientB["Client B (Recipient)"]
        B_Input["User Input:<br/>Room ID & Password"]:::client
        B_KeyDerive["AES-256 Key Derivation<br/>(Identical Key derived locally)"]:::crypto
        B_RoomHash["SHA-256 Room Hashing"]:::crypto
        B_Fetch["Fetch Ciphertext stream"]:::client
        B_Decrypt["Client-Side AES Decryption"]:::crypto
        B_MsgPlain["Decrypted Plaintext"]:::client
    end

    %% Flow linkages
    A_Input --> A_KeyDerive
    A_Input --> A_RoomHash
    A_MsgPlain & A_KeyDerive --> A_Encrypt
    A_Encrypt --> A_MsgCipher

    A_RoomHash -->|Join / Create Room| F_Rooms
    A_MsgCipher -->|Publish Stream| F_Messages

    B_Input --> B_KeyDerive
    B_Input --> B_RoomHash
    B_RoomHash -->|Connect to Room Hash| F_Rooms
    F_Messages -->|Listen to Updates| B_Fetch
    B_Fetch & B_KeyDerive --> B_Decrypt
    B_Decrypt --> B_MsgPlain
```

---

## 📱 Screenshots

<p align="center" float="left">
  <img src="https://github.com/ArjunKVarma/Sessions-Chat_Rooms_an_Private_Messenger/blob/master/Images/login.jpg" alt="Login Page" width="200" style="margin: 10px; border-radius: 10px;">
  <img src="https://github.com/ArjunKVarma/Sessions-Chat_Rooms_an_Private_Messenger/blob/master/Images/home.jpg" alt="Home Page" width="200" style="margin: 10px; border-radius: 10px;">
  <img src="https://github.com/ArjunKVarma/Sessions-Chat_Rooms_an_Private_Messenger/blob/master/Images/chat.jpg" alt="Chat Interface" width="200" style="margin: 10px; border-radius: 10px;">
  <img src="https://github.com/ArjunKVarma/Sessions-Chat_Rooms_an_Private_Messenger/blob/master/Images/delete.jpg" alt="Delete Room" width="200" style="margin: 10px; border-radius: 10px;">
</p>

---

## 🚀 Setup & Contributions

To set up the development environment locally:

1. **Clone & Setup:**
   ```bash
   git clone https://github.com/ArjunKVarma/Sessions-Chat_Rooms_an_Private_Messenger.git
   cd Sessions-Chat_Rooms_an_Private_Messenger
   ```
2. **Fetch Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Configure Firebase:** Set up your Firebase project and add your `google-services.json` to the `android/app` directory.
4. **Run Application:**
   ```bash
   flutter run
   ```

*Thank you for contributing to keeping Sessions anonymous, secure, and lightning-fast!*
