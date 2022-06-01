# Moat Builders

## Developer Task

### Description

We would like you to create a music collection app. This task is to check your skills on code pattern, code organization and software architecture experience.

We value everyone's time a lot! So it is not without serious consideration that we decided to add this step to our hiring process. Although it might take you a bit of your time to build the app, it will be very valuable for us, because your skills will do all the hard work in the hiring process. This app is how we will judge your skills.

While building the app, please consider the following:

Apply basic UX patterns to the UI - don't worry too much about the design, but please use bootstrap or equivalent

It's highly recommended that you use a framework (backend and frontend)

We will look for your skills on Object-Oriented Programming (OOP), MVC (Model-View-Controller) pattern, SoC (Separation of Concerns), Best Practices, Documentation and Migrations

### Data Storage

For data storage, feel free to use any database you want.

This will be evaluated as per: Conventions, Patterns and Schema


### Requirements

**Register**

- Create a basic registration page
- You should have:
    - `full name`
    - `username`
    - `password`
    - `role` (you will have `user` and `admin`)

**Login**

- Create a basic login page with the fields `username` and `password`
- Once logged in the user should be able to access all internal pages of the music app
    - If a not-logged in user tries to access any internal page he should be redirected to the login page
- After a successful login the user should be redirected to the `Artists list` page
- A failed login attempt will send the user back to the login page with the error: `Sorry, we couldn't find an account with this username. Please check you're using the right username and try again.`

**Albums**

- Create a CRUD for the albums
- Only admins can `DELETE` albums (users can add and edit)
- Each album will contain the following fields:
    - `Artist` let user select from the list of existing artists
    - `Album name`
    - `Year`

**Artist List**

- Only allowed artists should be accepted by the app. The app must load the list of artists from an API.

- Endpoints:
    - `https://www.moat.ai/api/task/` - return a list of artists link
    - `https://www.moat.ai/api/task/?artist_id=<artist_id>` - return the artists data link
    - Authorization:
        - None
    - Header:
        - Set `Basic ZGV2ZWxvcGVyOlpHVjJaV3h2Y0dWeQ==` on Header

- There's no need to cache the list. It is ok to pull it from the API whenever the list is needed.
- This list should be used to populate the select box (or equivalent) used to select the artist of the album.

### Deploying and Presenting

Once done, please consider the following:

- Make sure that you've committed the framework code first, and your changes later in separated commits. This is important so that we can clearly identify your code and changes separated from the framework files

    - Do not rebase your code with the initial commit when you're pushing the framework code, or it will be harder for us to look at just your code

- Send us the link to a public repository with the app code

	- A deployed and running version that we could test is a bonus


Feel free to come up with any requirement omitted from the specification (eg: error messages, user-flows, etc). Just keep in mind that we're not looking for completeness of features nor design. You should not need to spend more than a few hours on this task.
