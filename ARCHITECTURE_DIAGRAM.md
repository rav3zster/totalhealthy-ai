# Trainer-Client Management Architecture

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         FIREBASE FIRESTORE                       │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  User Collection                                        │    │
│  │  ┌──────────────────────────────────────────────────┐  │    │
│  │  │  Document: user_uid_1                            │  │    │
│  │  │  {                                                │  │    │
│  │  │    id: "user_uid_1",                             │  │    │
│  │  │    email: "member@example.com",                  │  │    │
│  │  │    role: "member",                    ◄─────────┐│  │    │
│  │  │    assignedTrainerId: "trainer_uid"  ◄─────────┐││  │    │
│  │  │    ...other fields                              │││  │    │
│  │  │  }                                               │││  │    │
│  │  └──────────────────────────────────────────────────┘││  │    │
│  │                                                       ││  │    │
│  │  ┌──────────────────────────────────────────────────┐││  │    │
│  │  │  Document: trainer_uid                           │││  │    │
│  │  │  {                                                │││  │    │
│  │  │    id: "trainer_uid",                            │││  │    │
│  │  │    email: "trainer@example.com",                 │││  │    │
│  │  │    role: "trainer",               ◄──────────────┘│  │    │
│  │  │    assignedTrainerId: null                        │  │    │
│  │  │    ...other fields                                │  │    │
│  │  │  }                                                 │  │    │
│  │  └──────────────────────────────────────────────────┘  │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │
                              │ Real-time Streams
                              │
┌─────────────────────────────┴───────────────────────────────────┐
│                    FLUTTER APPLICATION                           │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  UsersFirestoreService                                  │    │
│  │  ┌──────────────────────────────────────────────────┐  │    │
│  │  │  getUsersByRoleStream('member')                   │  │    │
│  │  │  ├─ Filters users where role == 'member'         │  │    │
│  │  │  └─ Returns Stream<List<UserModel>>              │  │    │
│  │  │                                                    │  │    │
│  │  │  getTrainerClientsStream(trainerId)              │  │    │
│  │  │  ├─ Filters users where assignedTrainerId ==     │  │    │
│  │  │  │  trainerId                                     │  │    │
│  │  │  └─ Returns Stream<List<UserModel>>              │  │    │
│  │  │                                                    │  │    │
│  │  │  assignClientToTrainer(clientId, trainerId)      │  │    │
│  │  │  ├─ Updates user document                        │  │    │
│  │  │  └─ Sets assignedTrainerId field                 │  │    │
│  │  └──────────────────────────────────────────────────┘  │    │
│  └────────────────────────────────────────────────────────┘    │
│                              │                                   │
│                              │                                   │
│  ┌───────────────────────────┴──────────────────────────────┐  │
│  │                                                            │  │
│  │  ┌──────────────────────┐    ┌──────────────────────┐   │  │
│  │  │  Client List Screen  │    │  Trainer Dashboard   │   │  │
│  │  │                      │    │                      │   │  │
│  │  │  Shows:              │    │  Shows:              │   │  │
│  │  │  • Members only      │    │  • "Your Clients"    │   │  │
│  │  │  • Not assigned yet  │    │  • Assigned clients  │   │  │
│  │  │  • Search bar        │    │  • Live stats        │   │  │
│  │  │  • Add Client button │    │  • Add Client button │   │  │
│  │  │                      │    │                      │   │  │
│  │  │  Actions:            │    │  Actions:            │   │  │
│  │  │  • Search members    │    │  • View clients      │   │  │
│  │  │  • Add client        │    │  • Navigate to diet  │   │  │
│  │  │  • Contact member    │    │  • Contact client    │   │  │
│  │  └──────────────────────┘    └──────────────────────┘   │  │
│  │                                                            │  │
│  └────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Diagram

### Add Client Flow

```
┌─────────────┐
│   Trainer   │
│  Dashboard  │
└──────┬──────┘
       │
       │ 1. Clicks "Add Client"
       ▼
┌─────────────┐
│   Client    │
│  List Screen│
└──────┬──────┘
       │
       │ 2. Loads members
       │    (role == "member")
       │    (not assigned to this trainer)
       ▼
┌─────────────────────────────────┐
│  Firebase Query:                │
│  getUsersByRoleStream('member') │
│  ├─ WHERE role == 'member'      │
│  └─ EXCLUDE assignedTrainerId   │
│     == current_trainer_uid      │
└──────┬──────────────────────────┘
       │
       │ 3. Displays members
       ▼
┌─────────────┐
│  Member     │
│  Cards      │
│  ┌────────┐ │
│  │ Member │ │
│  │  Card  │ │
│  │ [Add]  │ │
│  └────────┘ │
└──────┬──────┘
       │
       │ 4. Trainer clicks "Add Client"
       ▼
┌─────────────────────────────────┐
│  assignClientToTrainer()        │
│  ├─ clientId: member_uid        │
│  └─ trainerId: trainer_uid      │
└──────┬──────────────────────────┘
       │
       │ 5. Updates Firebase
       ▼
┌─────────────────────────────────┐
│  Firebase Update:               │
│  user/member_uid                │
│  {                              │
│    assignedTrainerId:           │
│      "trainer_uid"              │
│  }                              │
└──────┬──────────────────────────┘
       │
       │ 6. Real-time update
       ▼
┌─────────────────────────────────┐
│  All Listening Screens Update:  │
│  ├─ Client List: Remove member  │
│  └─ Trainer Dashboard: Add      │
│     client to "Your Clients"    │
└─────────────────────────────────┘
```

---

## Component Interaction

```
┌────────────────────────────────────────────────────────────────┐
│                      TRAINER DASHBOARD                          │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │  Header                                                   │ │
│  │  ┌────────────┐  ┌────────────────────────────────────┐ │ │
│  │  │  Profile   │  │  Live Stats                        │ │ │
│  │  │  Avatar    │  │  ┌──────┐ ┌──────┐ ┌──────┐       │ │ │
│  │  │            │  │  │  03  │ │  05  │ │  07  │       │ │ │
│  │  │            │  │  │Clients│ │Plans │ │Pending│      │ │ │
│  │  └────────────┘  │  └──────┘ └──────┘ └──────┘       │ │ │
│  │                  └────────────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │  Search Bar                                              │ │
│  │  ┌────────────────────────────────┐  ┌──────────┐      │ │
│  │  │  Search here...                │  │  Search  │      │ │
│  │  └────────────────────────────────┘  └──────────┘      │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │  Your Clients                    [+ Add Client]          │ │
│  │  ┌────────────────────────────────────────────────────┐ │ │
│  │  │  ┌────┐  John Doe                    ┌────┐        │ │ │
│  │  │  │ 👤 │  john@example.com            │ 📧 │        │ │ │
│  │  │  └────┘  ████████░░ 85%              └────┘        │ │ │
│  │  │                                       ┌────┐        │ │ │
│  │  │                                       │ 📞 │        │ │ │
│  │  │                                       └────┘        │ │ │
│  │  └────────────────────────────────────────────────────┘ │ │
│  │  ┌────────────────────────────────────────────────────┐ │ │
│  │  │  ┌────┐  Jane Smith                  ┌────┐        │ │ │
│  │  │  │ 👤 │  jane@example.com            │ 📧 │        │ │ │
│  │  │  └────┘  ██████████ 100%             └────┘        │ │ │
│  │  │                                       ┌────┐        │ │ │
│  │  │                                       │ 📞 │        │ │ │
│  │  │                                       └────┘        │ │ │
│  │  └────────────────────────────────────────────────────┘ │ │
│  └──────────────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────────────┘
                              │
                              │ Click "Add Client"
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                      CLIENT LIST SCREEN                         │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │  [←]  Client List                                        │ │
│  │     