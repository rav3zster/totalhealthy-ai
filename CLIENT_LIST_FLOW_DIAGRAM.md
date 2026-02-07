# Client List Flow Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         FIREBASE                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Collection: user                                         │  │
│  │  ┌────────────────┐  ┌────────────────┐  ┌────────────┐ │  │
│  │  │ Member 1       │  │ Member 2       │  │ Trainer    │ │  │
│  │  │ role: member   │  │ role: member   │  │ role:      │ │  │
│  │  │ assigned: null │  │ assigned: T123 │  │  trainer   │ │  │
│  │  └────────────────┘  └────────────────┘  └────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              ↕ (Real-time Streams)
┌─────────────────────────────────────────────────────────────────┐
│                    FLUTTER APP                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  UsersFirestoreService                                    │  │
│  │  • getUsersStream()                                       │  │
│  │  • getUsersByRoleStream(role)                            │  │
│  │  • getTrainerClientsStream(trainerId)                    │  │
│  │  • assignClientToTrainer(clientId, trainerId)            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↕                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Client List Screen                                       │  │
│  │  • Loads all members                                      │  │
│  │  • Filters out assigned clients                          │  │
│  │  • Provides search functionality                         │  │
│  │  • Handles client assignment                             │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              ↕                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Trainer Dashboard                                        │  │
│  │  • Shows "Your Clients"                                   │  │
│  │  • Displays assigned clients                             │  │
│  │  • "Add Client" button                                    │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow: Loading Members

```
┌──────────────────┐
│ Client List      │
│ Screen Opens     │
└────────┬─────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 1. Get Current Trainer UID             │
│    FirebaseAuth.instance.currentUser   │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 2. Start Two Streams                   │
│    a) Assigned Clients Stream          │
│    b) All Users Stream                 │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 3. Filter Users                        │
│    • Exclude current trainer           │
│    • Exclude assigned clients          │
│    • Include only members or no role   │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 4. Display Member Cards                │
│    • Show profile info                 │
│    • Show "Add Client" button          │
│    • Enable search                     │
└────────────────────────────────────────┘
```

## Data Flow: Adding a Client

```
┌──────────────────┐
│ User Clicks      │
│ "Add Client"     │
└────────┬─────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 1. Show Loading State                  │
│    addingClients.add(client.id)        │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 2. Call Firebase Service               │
│    assignClientToTrainer(              │
│      clientId, trainerId)              │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 3. Update Firebase                     │
│    user/clientId:                      │
│      assignedTrainerId = trainerId     │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 4. Success Response                    │
│    • Show success snackbar             │
│    • Remove from local list            │
│    • Hide loading state                │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ 5. Real-time Update                    │
│    • Assigned clients stream updates   │
│    • Client appears on dashboard       │
│    • Client removed from available     │
└────────────────────────────────────────┘
```

## Filtering Logic

```
┌─────────────────────────────────────────────────────────┐
│                    ALL USERS IN FIREBASE                 │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐     │
│  │User 1│  │User 2│  │User 3│  │User 4│  │User 5│     │
│  │Member│  │Member│  │Trainer│ │Member│  │Member│     │
│  │Free  │  │Assign│  │      │  │Free  │  │Free  │     │
│  └──────┘  └──────┘  └──────┘  └──────┘  └──────┘     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│              FILTER 1: Exclude Current User              │
│  ┌──────┐  ┌──────┐            ┌──────┐  ┌──────┐     │
│  │User 1│  │User 2│            │User 4│  │User 5│     │
│  │Member│  │Member│            │Member│  │Member│     │
│  │Free  │  │Assign│            │Free  │  │Free  │     │
│  └──────┘  └──────┘            └──────┘  └──────┘     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│         FILTER 2: Exclude Assigned Clients               │
│  ┌──────┐                      ┌──────┐  ┌──────┐     │
│  │User 1│                      │User 4│  │User 5│     │
│  │Member│                      │Member│  │Member│     │
│  │Free  │                      │Free  │  │Free  │     │
│  └──────┘                      └──────┘  └──────┘     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│    FILTER 3: Only Members or Users Without Role          │
│  ┌──────┐                      ┌──────┐  ┌──────┐     │
│  │User 1│                      │User 4│  │User 5│     │
│  │Member│                      │Member│  │Member│     │
│  │Free  │                      │Free  │  │Free  │     │
│  └──────┘                      └──────┘  └──────┘     │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│              RESULT: Available Members                   │
│         Displayed in Client List Screen                  │
└─────────────────────────────────────────────────────────┘
```

## Search Flow

```
┌──────────────────┐
│ User Types in    │
│ Search Box       │
└────────┬─────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ _filterMembers(query)                  │
└────────┬───────────────────────────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ Check if query is empty                │
└────────┬───────────────────────────────┘
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    ↓         ↓
┌───────┐  ┌──────────────────────────┐
│ Show  │  │ Filter by:               │
│ All   │  │ • username.contains()    │
│ Members│  │ • email.contains()       │
└───────┘  │ • fullName.contains()    │
           └──────────┬───────────────┘
                      │
                      ↓
           ┌──────────────────────────┐
           │ Update filteredMembers   │
           │ Display results          │
           └──────────────────────────┘
```

## State Management

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENT LIST STATE                     │
│                                                          │
│  allMembers: List<UserModel>                            │
│    ↳ All available members from Firebase                │
│                                                          │
│  filteredMembers: List<UserModel>                       │
│    ↳ Members after search filter applied                │
│                                                          │
│  assignedClientIds: Set<String>                         │
│    ↳ IDs of clients already assigned to trainer         │
│                                                          │
│  addingClients: Set<String>                             │
│    ↳ IDs of clients currently being added (loading)     │
│                                                          │
│  isLoading: bool                                        │
│    ↳ Initial loading state                              │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Error Handling

```
┌──────────────────┐
│ Operation Starts │
└────────┬─────────┘
         │
         ↓
┌────────────────────────────────────────┐
│ Try Block                              │
│ • Firebase operation                   │
└────────┬───────────────────────────────┘
         │
    ┌────┴────┐
    │         │
 SUCCESS    ERROR
    │         │
    ↓         ↓
┌───────┐  ┌──────────────────────────┐
│Success│  │ Catch Block              │
│Snackbar│  │ • Log error             │
│       │  │ • Show error snackbar    │
│Update │  │ • Restore state          │
│UI     │  └──────────────────────────┘
└───────┘           │
    │               │
    └───────┬───────┘
            ↓
┌────────────────────────────────────────┐
│ Finally Block                          │
│ • Remove loading state                 │
│ • Clean up resources                   │
└────────────────────────────────────────┘
```

## Real-time Updates

```
Firebase Change
      ↓
Stream Emits New Data
      ↓
┌─────────────────────────────────────┐
│ Stream Listener Receives Update     │
└─────────────────┬───────────────────┘
                  │
                  ↓
┌─────────────────────────────────────┐
│ setState() Called                   │
│ • Update allMembers                 │
│ • Update assignedClientIds          │
│ • Trigger re-filter                 │
└─────────────────┬───────────────────┘
                  │
                  ↓
┌─────────────────────────────────────┐
│ UI Rebuilds Automatically           │
│ • New member cards appear           │
│ • Assigned clients disappear        │
│ • Counts update                     │
└─────────────────────────────────────┘
```

## Component Interaction

```
┌──────────────────────────────────────────────────────────┐
│                    TRAINER DASHBOARD                      │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Header: "Your Clients"                            │ │
│  │  Button: "Add Client" ──────────────┐             │ │
│  │                                      │             │ │
│  │  Client Cards (Assigned)             │             │ │
│  │  • Shows assigned clients only       │             │ │
│  │  • Real-time updates                 │             │ │
│  └──────────────────────────────────────┼─────────────┘ │
└─────────────────────────────────────────┼───────────────┘
                                          │
                                          │ Navigate
                                          │
                                          ↓
┌──────────────────────────────────────────────────────────┐
│                    CLIENT LIST SCREEN                     │
│  ┌────────────────────────────────────────────────────┐ │
│  │  Header: "Client List"                             │ │
│  │  Search Bar                                        │ │
│  │                                                    │ │
│  │  Available Member Cards                            │ │
│  │  • Shows unassigned members                        │ │
│  │  • "Add Client" button on each                     │ │
│  │  • Real-time filtering                             │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
                          │
                          │ Add Client
                          │
                          ↓
┌──────────────────────────────────────────────────────────┐
│                      FIREBASE UPDATE                      │
│  user/clientId:                                          │
│    assignedTrainerId = trainerId                         │
└──────────────────────────────────────────────────────────┘
                          │
                          │ Stream Update
                          │
                          ↓
┌──────────────────────────────────────────────────────────┐
│                    BOTH SCREENS UPDATE                    │
│  • Client removed from Client List                       │
│  • Client appears in Trainer Dashboard                   │
└──────────────────────────────────────────────────────────┘
```
