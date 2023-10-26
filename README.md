# README

Laurus is a developer portal application built with Rails. It's designed for organizations with an API who need to manage access and settings to their API resources for a community of developers. 

It also provides the front-end interface for developers to manage their own app's settings with the API provider. They can manage team members and request access to additional things such as restricted endpoints and increased rate limits.

This is a personal project of mine and very much a work in progress. I don't recommend anyone use this for a production API anytime soon.

To Do List:
* Full audit log for changes to apps, endpoints, and provisionings.
* A useful seeds file
* A better README with setup instructions.
* Add the ability to interact with the application through a REST API.
* Manage default and custom rate limits per app.
* Login with OAuth(likely LinkedIn only). 
* Customization of the navbar logo/text.
* Customize default security schemes and issuance of API secrets for new apps.
* Portal for developers to request access to restricted APIs.
* Admin portal to manage developer requests and grant/deny acccess.
* Payment integration into tools like Stripe to manage paid APIs.
* Create custom user roles and permissions.
* Manage OAuth scopes for APIs secured with OAuth.
* Automate creation/updating of endpoint objects in the app by parsing OpenAPI specs.
* Customization of client ID format.
* Ability for developers to subscribe to a newsletter and app notifications like downtime or hitting rate limits.
* Customize user display time zone
