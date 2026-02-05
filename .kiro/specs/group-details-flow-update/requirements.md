# Requirements Document

## Introduction

This specification defines the requirements for updating the Group Details flow in a Flutter application to properly separate accepted group members from invited or non-member users. The current implementation incorrectly displays all system users instead of actual group members, lacks clear admin identification, and mixes member display with invitation functionality.

## Glossary

- **Group_Details_Screen**: The main screen displaying group information and member list
- **Group_Admin**: The user who created the group and has administrative privileges
- **Active_Member**: A user who has accepted a group invitation and is currently part of the group
- **Member_Management_Screen**: A dedicated screen for managing group invitations and members
- **Group_Description_Card**: The UI component displaying group information and management options
- **Group_Controller**: The GetX controller managing group state and operations
- **Group_Model**: The data model representing group structure and member information
- **Invitation_System**: The notification-based system for sending and managing group invitations

## Requirements

### Requirement 1: Correct Member Display

**User Story:** As a group member, I want to see only actual group members on the Group Details screen, so that I have an accurate view of who is in my group.

#### Acceptance Criteria

1. WHEN viewing the Group Details screen, THE Group_Details_Screen SHALL display only users who have accepted group invitations and are active members
2. WHEN displaying the member list, THE Group_Details_Screen SHALL exclude all non-member users and pending invitations
3. WHEN counting members, THE Group_Details_Screen SHALL show the count based on actual accepted members only
4. WHEN loading member data, THE Group_Controller SHALL filter users to return only Active_Members

### Requirement 2: Group Admin Identification

**User Story:** As a group member, I want to clearly identify who the group admin is, so that I know who has administrative control over the group.

#### Acceptance Criteria

1. WHEN displaying the member list, THE Group_Details_Screen SHALL always show the Group_Admin at the top of the list
2. WHEN displaying the Group_Admin, THE Group_Details_Screen SHALL include a distinct visual label identifying them as "Group Admin" or "Owner"
3. THE Group_Model SHALL maintain proper identification of the group creator as Group_Admin
4. WHEN rendering member items, THE Group_Details_Screen SHALL apply different styling to distinguish the Group_Admin from regular members

### Requirement 3: Separated Member Management

**User Story:** As a group admin, I want dedicated member management functionality separate from the member display, so that I can efficiently manage group invitations without confusion.

#### Acceptance Criteria

1. WHEN viewing the Group Description Card, THE Group_Description_Card SHALL include a dedicated "Manage Members" or "Add Clients" button
2. WHEN the management button is pressed, THE Group_Description_Card SHALL navigate to the Member_Management_Screen
3. THE Group_Details_Screen SHALL NOT display invitation functionality mixed with the member list
4. THE Member_Management_Screen SHALL provide dedicated interfaces for invitation management

### Requirement 4: Member Management Screen

**User Story:** As a group admin, I want a dedicated screen for managing group members and invitations, so that I can efficiently handle all member-related operations in one place.

#### Acceptance Criteria

1. WHEN accessing the Member_Management_Screen, THE Member_Management_Screen SHALL display all available users who can be invited to the group
2. WHEN displaying invitation candidates, THE Member_Management_Screen SHALL show current invitation status for each user
3. WHEN managing invitations, THE Member_Management_Screen SHALL allow sending new invitations to eligible users
4. WHEN displaying current members, THE Member_Management_Screen SHALL provide removal functionality for the Group_Admin
5. THE Member_Management_Screen SHALL clearly separate invited users from current Active_Members

### Requirement 5: Data Model Enhancement

**User Story:** As a developer, I want proper data models for group membership tracking, so that the application can accurately represent group structure and member relationships.

#### Acceptance Criteria

1. THE Group_Model SHALL maintain a list of accepted member IDs separate from invitation data
2. THE Group_Model SHALL store Group_Admin identification information
3. WHEN updating member status, THE Group_Model SHALL properly track invitation acceptance and member activation
4. THE Group_Model SHALL support querying for Active_Members only
5. WHEN serializing group data, THE Group_Model SHALL include member status information for Firestore storage

### Requirement 6: Controller Functionality

**User Story:** As a developer, I want enhanced controller methods for member management, so that the UI can properly interact with group membership data.

#### Acceptance Criteria

1. THE Group_Controller SHALL provide methods to retrieve only Active_Members for a group
2. THE Group_Controller SHALL include functionality for adding and removing group members
3. WHEN handling invitations, THE Group_Controller SHALL update member status appropriately through the Invitation_System
4. THE Group_Controller SHALL maintain real-time synchronization with Firestore for member data
5. WHEN managing members, THE Group_Controller SHALL validate Group_Admin permissions before allowing modifications

### Requirement 7: Integration with Existing Systems

**User Story:** As a user, I want the updated group flow to work seamlessly with existing notification and invitation systems, so that my current workflows remain functional.

#### Acceptance Criteria

1. THE Member_Management_Screen SHALL integrate with the existing Invitation_System for sending invitations
2. WHEN invitations are accepted, THE Group_Controller SHALL automatically update the Active_Members list
3. THE updated flow SHALL maintain compatibility with existing notification handling
4. WHEN members join or leave, THE Group_Controller SHALL trigger appropriate notifications through existing systems