# README

This is a social media clone built on Ruby on Rails. It is publicly accessible [here](social-rails-sandi.online). Video demo [here]().

Development details:
 - pipeline with capybara tests and rubocop linting
 - designed with the bootstrap CSS framework
 - login of users handled with a session controller
 - turbo used for dynamic javascript updates
 - population script with faker
 - Dockerfile for production (and development to test production)
 - database handled with dockerized PostgreSQL
 - image loading handled with active storage and Cloudinary
 - hosting done with Northflank free tier, linked with Namecheap domain

Features:
 - User registration
 - Users can upload a profile photo, background image and change their bio
 - Posts can be uploaded and edited by users with up to 5 images per post with a description
 - Posts are private by default
 - Posts have a preview that can be viewed by users before being saved
 - Some sample public posts already available
 - Comments can be written (and deleted) on posts by users that posted them
 - Likes can be given to posts
 - Users can add friends in order to see their posts
 - SOON: friends can message eachother

Future work:
- I18n for more consistency
- more DRYing up, and slightly better code organization
- more tests