# Firebase Security Rules Update

## Required Firestore Rules

To support the trainer-client management system, update your Firestore security rules to allow:
1. Trainers to read all members (for Client List)
2. Trainers to update client assignments
3. Users to read their own data
4. Proper role-based access control

## Recommended Firestore Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isSignedIn() {
      return request.auth != null;
    }
    
    // Helper function to check if user is the document owner
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // Helper function to check if user is a trainer/advisor
    function isTrainer() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/user/$(request.auth.uid)).data.role in ['trainer', 'advisor'];
    }
    
    // Helper function to check if user is a member
    function isMember() {
      return isSignedIn() && 
             get(/databases/$(database)/documents/user/$(request.auth.uid)).data.role == 'member';
    }
    
    // User collection rules
    match /user/{userId} {
      // Allow users to read their own data
      allow read: if isSignedIn() && isOwner(userId);
      
      // Allow trainers to read all member profiles (for Client List)
      allow read: if isSignedIn() && isTrainer();
      
      // Allow users to create their own profile
      allow create: if isSignedIn() && isOwner(userId);
      
      // Allow users to update their own profile
      allow update: if isSignedIn() && isOwner(userId);
      
      // Allow trainers to update assignedTrainerId field for members
      allow update: if isSignedIn() && 
                       isTrainer() && 
                       request.resource.data.diff(resource.data).affectedKeys().hasOnly(['assignedTrainerId']);
      
      // Allow users to delete their own profile
      allow delete: if isSignedIn() && isOwner(userId);
    }
    
    // Groups collection rules (existing)
    match /groups/{groupId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() && 
                       (resource.data.created_by == request.auth.uid || 
                        request.auth.uid in resource.data.members_list);
      allow delete: if isSignedIn() && resource.data.created_by == request.auth.uid;
    }
    
    // Notifications collection rules (existing)
    match /notifications/{notificationId} {
      allow read: if isSignedIn() && 
                     (resource.data.recipientId == request.auth.uid || 
                      resource.data.senderId == request.auth.uid);
      allow create: if isSignedIn();
      allow update: if isSignedIn() && resource.data.recipientId == request.auth.uid;
      allow delete: if isSignedIn() && resource.data.recipientId == request.auth.uid;
    }
    
    // Meals collection rules (existing)
    match /meals/{mealId} {
      allow read: if isSignedIn();
      allow create: if isSignedIn();
      allow update: if isSignedIn() && resource.data.userId == request.auth.uid;
      allow delete: if isSignedIn() && resource.data.userId == request.auth.uid;
    }
  }
}
```

## Key Security Features

### 1. Role-Based Access Control
- Trainers can read all member profiles (needed for Client List)
- Members can only read their own profile
- Trainers cannot modify member data except `assignedTrainerId`

### 2. Assignment Protection
- Only trainers can assign clients to themselves
- Trainers can only modify the `assignedTrainerId` field
- Other user data remains protected

### 3. Self-Service
- Users can create and update their own profiles
- Users can delete their own accounts

### 4. Existing Features Protected
- Groups, notifications, and meals rules remain unchanged
- No breaking changes to existing functionality

## Testing Security Rules

### Test 1: Trainer Can Read Members
```dart
// Should succeed
final members = await FirebaseFirestore.instance
    .collection('user')
    .where('role', isEqualTo: 'member')
    .get();
```

### Test 2: Member Cannot Read Other Members
```dart
// Should fail with permission denied
final otherMembers = await FirebaseFirestore.instance
    .collection('user')
    .where('role', isEqualTo: 'member')
    .get();
```

### Test 3: Trainer Can Assign Client
```dart
// Should succeed
await FirebaseFirestore.instance
    .collection('user')
    .doc(clientId)
    .update({'assignedTrainerId': trainerId});
```

### Test 4: Trainer Cannot Modify Other Fields
```dart
// Should fail with permission denied
await FirebaseFirestore.instance
    .collection('user')
    .doc(clientId)
    .update({
      'assignedTrainerId': trainerId,
      'email': 'hacker@example.com' // This should be rejected
    });
```

### Test 5: Member Can Update Own Profile
```dart
// Should succeed
await FirebaseFirestore.instance
    .collection('user')
    .doc(currentUserId)
    .update({'weight': 75.5});
```

## Firestore Indexes

For optimal performance, create these indexes:

### Index 1: Users by Role
```
Collection: user
Fields: role (Ascending), email (Ascending)
Query Scope: Collection
```

### Index 2: Clients by Trainer
```
Collection: user
Fields: assignedTrainerId (Ascending), email (Ascending)
Query Scope: Collection
```

### Creating Indexes

**Option 1: Firebase Console**
1. Go to Firebase Console → Firestore Database
2. Click "Indexes" tab
3. Click "Create Index"
4. Add the fields as specified above

**Option 2: Automatic (Recommended)**
- Run the app and perform the queries
- Firebase will show an error with a link to create the index
- Click the link to auto-create the index

**Option 3: firebase.json**
```json
{
  "firestore": {
    "indexes": [
      {
        "collectionGroup": "user",
        "queryScope": "COLLECTION",
        "fields": [
          { "fieldPath": "role", "order": "ASCENDING" },
          { "fieldPath": "email", "order": "ASCENDING" }
        ]
      },
      {
        "collectionGroup": "user",
        "queryScope": "COLLECTION",
        "fields": [
          { "fieldPath": "assignedTrainerId", "order": "ASCENDING" },
          { "fieldPath": "email", "order": "ASCENDING" }
        ]
      }
    ]
  }
}
```

## Deployment Steps

### 1. Update Firestore Rules
```bash
# Using Firebase CLI
firebase deploy --only firestore:rules
```

### 2. Create Indexes
- Either use Firebase Console or let Firebase auto-create them

### 3. Test in Development
- Test all security scenarios
- Verify no permission errors

### 4. Deploy to Production
- Deploy rules to production
- Monitor for any permission errors
- Have rollback plan ready

## Rollback Plan

If issues occur after deployment:

### Quick Rollback
```bash
# Revert to previous rules
firebase deploy --only firestore:rules --project your-project-id
```

### Manual Rollback
1. Go to Firebase Console → Firestore Database
2. Click "Rules" tab
3. Click "History"
4. Select previous version
5. Click "Restore"

## Security Checklist

Before deploying:
- [ ] Rules allow trainers to read members
- [ ] Rules prevent members from reading other members
- [ ] Rules allow trainers to assign clients
- [ ] Rules prevent trainers from modifying other user data
- [ ] Rules allow users to update their own profiles
- [ ] Indexes are created
- [ ] Rules are tested in development
- [ ] Rollback plan is ready
- [ ] Team is notified of deployment

## Common Issues

### Issue: "Missing or insufficient permissions"
**Cause:** User doesn't have required role or rules are too restrictive  
**Solution:** Check user's `role` field in Firestore, verify rules are deployed

### Issue: "Index required" error
**Cause:** Firestore index not created  
**Solution:** Click the link in the error message to create the index

### Issue: Slow queries
**Cause:** Missing indexes  
**Solution:** Create the recommended indexes above

### Issue: Trainers can't see members
**Cause:** Rules not deployed or role field missing  
**Solution:** Deploy rules, verify users have `role` field

## Monitoring

After deployment, monitor:
- Firebase Console → Firestore → Usage tab
- Check for permission denied errors
- Monitor query performance
- Watch for unusual access patterns

## Support

If you encounter issues:
1. Check Firebase Console logs
2. Verify rules are deployed
3. Test with Firebase Emulator locally
4. Review security rules documentation: https://firebase.google.com/docs/firestore/security/get-started
