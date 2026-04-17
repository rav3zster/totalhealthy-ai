TotalHealthy: AI-Powered Nutrition and Meal Planning Application

Major Project - Project Progress Evaluation - II Report

submitted by
Mr. Raveend S
(USN: NNM24MC123)

Under the Guidance of
Ms. Shreya Shetty
Assistant Lecturer Grade I
Department of MCA
NMAM Institute of Technology, Nitte

Industry Mentor:
Mr. Manish Kumar
COO, Bright Infonet

To
Nitte (Deemed to be University)
(Estd. under Section 3, UGC Act 1956)
(Placed under Category A by MHRD, Govt. of India; Accredited as A+ Grade University by NAAC)

In partial fulfilment of the requirements for the award of
MASTER OF COMPUTER APPLICATIONS
DEPARTMENT OF MASTER OF COMPUTER APPLICATIONS
NMAM INSTITUTE OF TECHNOLOGY, NITTE
April, 2026


CERTIFICATE

This is to certify that the Progress Evaluation - II of the Major Project Work titled "TotalHealthy: AI-Powered Nutrition and Meal Planning Application" is a bonafide work carried out by Raveend S, NNM24MC123 under the guidance of Mr. Manish Kumar at Bright Infonet and co-guidance of Ms. Shreya Shetty in the Department of MCA, NMAM Institute of Technology, Nitte. The same is being submitted to the Nitte (Deemed to be University) in partial fulfilment of the requirements for the award of Master of Computer Applications.

Name and Signature of Guide(s)                          Name and Signature of HOD

Head of the Institution

Major Project: Project Progress Evaluation - II

Name of the Examiners                                   Signature with Date
1.
2.


ABSTRACT

The increasing prevalence of lifestyle diseases and poor dietary habits has created a strong demand for intelligent, personalized nutrition management tools. Most existing diet and meal planning applications rely on static meal databases and manual input, lacking the ability to generate truly personalized meal plans based on individual health goals, dietary restrictions, and activity levels. This project presents TotalHealthy, an AI-powered cross-platform mobile application built using Flutter that addresses this gap by combining real-time Firebase cloud services with an AI meal generation backend.

TotalHealthy serves two primary user roles: clients who manage their personal nutrition and trainers or advisors who oversee multiple clients through a group-based collaboration system. The application allows users to set personalized nutrition goals, generate AI-powered meal plans tailored to their dietary preferences and health objectives, track meal history, and schedule meal reminders. Trainers can create groups, assign meal categories, and monitor client progress through a dedicated dashboard.

The AI meal generation feature is powered by a Flask backend deployed on Render, which integrates with the OpenRouter API to use large language models for generating structured, constraint-aware meal plans. The system accepts detailed user preferences including goal, cuisine type, diet type, allergies, macro targets, and activity level, and returns a complete set of meals with nutritional information. A fallback mechanism and retry logic ensure reliability even when the AI model is unavailable.

The application is built on a modular MVC architecture using the GetX framework for state management and navigation, Firebase Authentication and Cloud Firestore for real-time data, and Firebase Storage for media. The project demonstrates the practical integration of mobile development, cloud computing, and artificial intelligence to deliver a complete, production-ready health and nutrition platform.


TABLE OF CONTENTS

Chapter 1   Introduction
1.1  Background of the Project
1.2  Problem Statement
1.3  Objectives of the Project
1.4  Scope and Limitations

Chapter 2   Literature Review
2.1  Mobile Health Applications
2.2  AI and Large Language Models in Nutrition
2.3  Real-Time Cloud Databases in Mobile Apps
2.4  Group-Based Health Coaching Platforms
2.5  Identified Research Gap

Chapter 3   Work Done
3.1  Overview of Development Phase
3.2  System Architecture
3.3  Module Description
3.4  AI Backend Design
3.5  Database Design

Chapter 4   Conclusion and Next Steps
4.1  Summary of Work Completed
4.2  Next Phase
4.3  Expected Outcomes

References


CHAPTER 1: INTRODUCTION

1.1 Background of the Project

The global rise in obesity, diabetes, and other diet-related chronic diseases has made personalized nutrition management a critical area of focus in digital health. Mobile applications have become a primary tool for individuals seeking to manage their diet and fitness, with millions of users relying on apps to track calories, plan meals, and monitor health metrics. However, the majority of these applications offer generic meal suggestions based on static databases and do not account for the full complexity of individual dietary needs, cultural food preferences, medical conditions, or real-time health goals.

Artificial intelligence, particularly large language models, has opened new possibilities for generating highly personalized, context-aware content. When applied to nutrition, these models can produce meal plans that respect a wide range of constraints simultaneously, including caloric targets, macronutrient distribution, allergen exclusions, cuisine preferences, and fitness goals. Combined with real-time cloud infrastructure, such systems can deliver dynamic, responsive nutrition guidance at scale.

This project, TotalHealthy, was developed during an internship at Bright Infonet to build a production-ready, AI-powered nutrition and meal planning application. The application targets both individual users and fitness professionals, providing a comprehensive platform for personalized meal management, group-based coaching, and AI-driven meal generation.

1.2 Problem Statement

Despite the availability of numerous diet and nutrition applications, several critical limitations persist. Most applications rely on pre-built meal databases that do not adapt to individual user preferences, cultural backgrounds, or specific health conditions. Users are required to manually search for and log meals, which is time-consuming and often inaccurate. Existing AI-based nutrition tools are either too generic, ignoring specific dietary constraints, or too expensive for everyday users.

Furthermore, there is a lack of platforms that effectively bridge the gap between individual clients and their fitness trainers or nutritional advisors. Trainers currently rely on manual communication and spreadsheets to manage client meal plans, which is inefficient and difficult to scale.

There is therefore a need for an integrated mobile application that combines AI-powered personalized meal generation, real-time cloud synchronization, multi-role support for both clients and trainers, and group-based collaboration features, all within a single, accessible platform.

1.3 Objectives of the Project

The main objective of this project is to design and develop a cross-platform mobile application that leverages artificial intelligence to provide personalized nutrition and meal planning services. The specific objectives are as follows:

To develop a Flutter-based cross-platform mobile application supporting both Android and iOS.

To implement a multi-role authentication system supporting client, trainer, and admin roles using Firebase Authentication.

To build an AI-powered meal generation system using a Flask backend integrated with large language models via the OpenRouter API.

To design a constraint-aware prompt engineering system that generates meals respecting user goals, dietary restrictions, allergies, cuisine preferences, and macro targets.

To implement real-time data synchronization using Cloud Firestore for meals, user profiles, and group data.

To develop a group-based collaboration system allowing trainers to create groups, assign meal categories, and manage client meal plans.

To build a meal history, meal timing, and reminder scheduling system for daily nutrition tracking.

To implement a nutrition goal wizard that collects user health data and preferences to personalize the experience.

To ensure code quality and maintainability through adherence to Dart and Flutter best practices.

1.4 Scope and Limitations

1.4.1 Scope of the Project

The project covers the full development of a mobile application for nutrition and meal planning, including user authentication, AI meal generation, meal management, group collaboration, notification scheduling, and settings management. The application supports two primary user roles and includes a dedicated backend service for AI processing. The system is designed for Android deployment with cross-platform compatibility.

1.4.2 Limitations of the Project

The AI meal generation feature depends on the availability of the OpenRouter API and the free-tier models used, which may have rate limits or occasional unavailability. The Flask backend is hosted on Render's free tier, which introduces a cold start delay of approximately 30 seconds after periods of inactivity. The application currently does not support offline mode, requiring an active internet connection for all core features. GCP Cloud Functions for advanced meal recommendation and nutrition prediction features are planned but not yet deployed. The application has not undergone formal user testing or clinical validation of the nutritional recommendations generated by the AI.


CHAPTER 2: LITERATURE REVIEW

This chapter reviews existing research and technologies related to mobile health applications, AI-based nutrition systems, real-time cloud databases, and group-based health coaching platforms. The survey establishes the technological background of the project and identifies the gap that TotalHealthy aims to address.

2.1 Mobile Health Applications

The field of mobile health, commonly referred to as mHealth, has grown significantly over the past decade. Klasnja and Pratt (2012) highlighted the potential of smartphones as health intervention tools, noting their ability to deliver personalized health information at the point of need. Applications such as MyFitnessPal and Cronometer have demonstrated the viability of mobile platforms for dietary tracking, but these rely primarily on user-driven manual logging and static food databases rather than intelligent generation.

2.2 AI and Large Language Models in Nutrition

Recent advances in large language models have opened new possibilities for intelligent dietary guidance. Brown et al. (2020) demonstrated that GPT-3 and similar models can generate coherent, contextually appropriate text across a wide range of domains, including health and nutrition. Subsequent work has shown that with appropriate prompt engineering, these models can produce structured outputs such as meal plans that respect complex dietary constraints. The use of OpenRouter as an API aggregator for accessing multiple LLMs provides flexibility and cost efficiency for production applications.

2.3 Real-Time Cloud Databases in Mobile Apps

Firebase Cloud Firestore, introduced by Google, provides a scalable, real-time NoSQL database suitable for mobile applications. Moroney (2017) described the advantages of Firebase for mobile development, including real-time listeners, offline support, and seamless integration with authentication services. The combination of Firestore with Flutter's reactive programming model enables efficient, real-time UI updates without manual polling.

2.4 Group-Based Health Coaching Platforms

Research by Mohr et al. (2013) on technology-based interventions for health behavior change emphasized the importance of social support and professional guidance in achieving sustained dietary improvements. Platforms that connect clients with coaches or trainers have shown better adherence outcomes compared to self-directed applications. However, most existing platforms lack integrated AI-powered meal generation and rely on manual plan creation by the trainer.

2.5 Identified Research Gap

While significant progress has been made in mobile health applications, AI-based content generation, and cloud-based data management, no existing solution effectively combines all three into a single, accessible platform. Current nutrition applications either lack AI personalization, do not support multi-role collaboration between clients and trainers, or require expensive subscriptions that limit accessibility. TotalHealthy addresses this gap by integrating AI meal generation, real-time cloud synchronization, and group-based coaching into a single Flutter application backed by a lightweight Flask AI service.


CHAPTER 3: WORK DONE

3.1 Overview of Development Phase

The development of TotalHealthy was carried out during the internship period at Bright Infonet. The project was built using Flutter for the mobile frontend, Firebase for authentication and real-time data, and a Flask backend for AI meal generation. The development followed a modular MVC architecture using the GetX framework, which provides state management, dependency injection, and navigation in a single package.

The development process began with system design and architecture planning, followed by the implementation of authentication and user management, then the core meal management features, the AI generation system, the group collaboration module, and finally the settings and notification systems. Code quality was maintained throughout by following Dart and Flutter best practices, with all lint issues resolved before each commit.

3.2 System Architecture

The application follows a three-tier architecture consisting of the Flutter mobile client, the Firebase cloud backend, and the Flask AI backend.

The Flutter client handles all user interface rendering, state management via GetX, and communication with both Firebase and the Flask backend. It is organized into 30 feature modules, each following the MVC pattern with separate binding, controller, and view files.

Firebase provides authentication via Firebase Auth, real-time data storage via Cloud Firestore, media storage via Firebase Storage, and push notifications via Firebase Cloud Messaging. The Firestore database contains four primary collections: users, meals, groups, and group_categories.

The Flask backend is deployed on Render and exposes six REST API endpoints. It receives meal generation requests from the Flutter client, constructs detailed prompts based on user preferences, calls the OpenRouter API to invoke large language models, parses and validates the AI response, and returns structured meal data to the client.

The navigation flow of the application is as follows. On launch, the app checks the Firebase authentication state. If the user is authenticated, it reads the stored role and navigates to either the client dashboard or the trainer dashboard. If the user is not authenticated, it navigates to the onboarding screen.

3.3 Module Description

The application is organized into 30 feature modules. The authentication and onboarding modules handle user registration, login, password reset, role selection, and the initial onboarding experience. The client dashboard module is the primary screen for client users, displaying meals by category, supporting search, and providing access to group mode where clients can view meals assigned by their trainer. The trainer dashboard module provides advisors with an overview of their clients and groups.

The meal management modules include create meal for manual meal creation with image upload, meal history for viewing and copying past meals, meals details for viewing full meal information, meal timing for scheduling daily meal times, and meal categories for browsing and managing meal categories. The generate AI module provides a multi-step form where users enter their dietary preferences and health goals, which are sent to the Flask backend to generate a personalized meal plan.

The group module allows trainers to create groups, invite members, manage group categories, and assign meals to group members. The planner, group meal calendar, and weekly meal planner modules provide scheduling interfaces for group-based meal planning.

The profile and settings modules allow users to manage their personal information, change passwords, configure notification preferences, and view privacy policy. The nutrition goal module provides a four-step wizard for setting nutrition goals, activity level, meal frequency, and dietary restrictions.

3.4 AI Backend Design

The Flask backend is the core of the AI meal generation feature. It is built using Flask with CORS support and deployed on Render. The primary endpoint is POST /generate_meal, which accepts a JSON body containing the user's goal, current weight, target weight, calorie and macro targets, diet type, allergies, cuisine preference, meals per day, meal types, preferred and avoided foods, exercise frequency, medical conditions, and special instructions.

The backend constructs a detailed prompt using this information, incorporating hard constraints for allergen exclusions, cuisine authenticity, diet type adherence, and macro distribution. A variety seeding mechanism selects a random theme hint for each generation to ensure meal diversity across multiple requests. A previousMeals parameter allows the client to pass previously generated meal names, which the prompt instructs the model to avoid repeating.

The prompt is sent to the OpenRouter API using the arcee-ai/trinity-mini:free model as the primary model and liquid/lfm-2.5-1.2b-instruct:free as the fallback. The response is parsed using a multi-stage JSON extraction process that handles both complete and truncated responses. Each parsed meal is validated and sanitized before being returned to the client. If all AI calls fail, a static fallback meal is returned to ensure the application remains functional.

Additional endpoints include POST /classify_diet for BMI and TDEE calculation with AI-based diet type recommendation, POST /explain_meal for generating a contextual explanation of a meal choice, and POST /scan_food for analyzing food images using a vision-capable model.

3.5 Database Design

The Firestore database uses four primary collections. The users collection stores one document per user identified by the Firebase Auth UID, containing profile information, health metrics, role, goals, and preferences. The meals collection stores meal documents linked to a user ID or group ID, containing the meal name, category, ingredients, nutritional information, and metadata. The groups collection stores group documents containing the group name, trainer ID, and member list. The group_categories collection stores custom meal category documents linked to a group ID.

Real-time listeners are used on the meals and group collections to ensure the client dashboard and group views update automatically when data changes in Firestore.


CHAPTER 4: CONCLUSION AND NEXT STEPS

4.1 Summary of Work Completed

The development phase of TotalHealthy has successfully delivered a fully functional, production-ready mobile application for AI-powered nutrition and meal planning. The following key components have been completed.

The complete Flutter application with 30 feature modules, multi-role authentication, and GetX-based state management and navigation has been implemented and deployed to the GitHub repository.

The Firebase integration covering authentication, real-time Firestore data synchronization, Firebase Storage for media, and FCM for push notifications is fully operational.

The Flask AI backend with six REST endpoints, constraint-aware prompt engineering, multi-model fallback, truncated JSON recovery, and variety seeding is deployed on Render and accessible at https://totalhealthy-ai.onrender.com.

The group collaboration system allowing trainers to create groups, manage categories, and assign meals to clients is complete.

The meal management system including manual meal creation, AI generation, meal history, meal timing, and reminder scheduling is fully implemented.

Code quality has been maintained with all Flutter lint issues resolved, confirmed by a clean flutter analyze result with no issues found.

4.2 Next Phase

The next phase of the project will focus on deploying the GCP Cloud Functions for advanced meal recommendation and nutrition prediction features, which are currently implemented in the client but return empty results due to the missing backend. Performance optimization of the Flask backend to reduce cold start latency on Render will also be addressed. Unit and widget tests will be written to improve code reliability. An offline caching mechanism will be implemented to allow basic app functionality without an internet connection.

4.3 Expected Outcomes of Complete Project

The completed project is expected to deliver a fully production-ready mobile application available on the Google Play Store that provides personalized AI-generated meal plans to individual users and enables fitness trainers to manage client nutrition through a group-based collaboration system. The application will support real-time meal tracking, reminder scheduling, and nutritional goal monitoring, demonstrating the practical application of large language models, cloud computing, and mobile development in the health technology domain.


REFERENCES

[1] P. Klasnja and W. Pratt, "Healthcare in the pocket: Mapping the space of mobile-phone health interventions," Journal of Biomedical Informatics, vol. 45, no. 1, pp. 184-198, 2012.

[2] T. B. Brown et al., "Language models are few-shot learners," in Advances in Neural Information Processing Systems (NeurIPS), vol. 33, pp. 1877-1901, 2020.

[3] L. Moroney, The Definitive Guide to Firebase, Apress, 2017.

[4] D. C. Mohr, M. Zhang, and S. M. Schueller, "Personal sensing: Understanding mental health using ubiquitous sensors and machine learning," Annual Review of Clinical Psychology, vol. 13, pp. 23-47, 2017.

[5] Google LLC, "Cloud Firestore Documentation," Available: https://firebase.google.com/docs/firestore, 2024.

[6] OpenRouter, "OpenRouter API Documentation," Available: https://openrouter.ai/docs, 2024.

[7] Flutter Team, "Flutter Documentation," Available: https://flutter.dev/docs, 2024.

[8] GetX Team, "GetX State Management Documentation," Available: https://pub.dev/packages/get, 2024.

[9] Render, "Render Cloud Platform Documentation," Available: https://render.com/docs, 2024.

[10] M. Armbrust et al., "A view of cloud computing," Communications of the ACM, vol. 53, no. 4, pp. 50-58, 2010.
