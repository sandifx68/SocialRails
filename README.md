# README

This is a social media clone built on Ruby on Rails. It will eventually be publicly accessible [here](social-rails-sandi.online).

Development details:
 - pipeline with capybara tests and rubocop linting
 - designed with the bootstrap CSS framework
 - database handled with dockerized PostgreSQL
 - login of users handled with a session controller
 - image loading handled with local active storage (soon Amazong S3)
 - SOON: hosted with google sites and linked to personal domain

Features:
 - User registration
 - Users can upload a profile photo, background image and change their bio
 - Posts can be uploaded and edited by users with up to 5 images per post with a description
 - Posts have a preview that can be viewed by users before being saved
 - Comments can be written (and deleted) on posts by users that
 - Likes can be given to posts
 - SOON: users can add friends
 - SOON: friends can message eachother

 TODO: add video demonstration of each feature?