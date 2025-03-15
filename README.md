# Bosba Clinique

A Ruby on Rails application for clinic management with Docker support.

## Prerequisites

- Docker and Docker Compose
- PostgreSQL (via Docker)
- AWS S3 for file storage
- Redis (for background jobs)

## Technology Stack

- **Backend:** Ruby on Rails
- **Database:** PostgreSQL
- **File Storage:** AWS S3
- **Container:** Docker
- **Background Processing:** Sidekiq with Redis
- **Testing:** RSpec
- **Code Quality:** RuboCop

## Project Structure

```
.
├── app/                    # Application code
│   ├── assets/            # Static assets
│   ├── channels/          # Action Cable channels
│   ├── controllers/       # Controllers
│   ├── helpers/           # View helpers
│   ├── interactors/       # Business logic/service objects
│   ├── javascript/        # JavaScript files
│   ├── jobs/             # Background jobs
│   ├── mailers/          # Email templates and logic
│   ├── models/           # ActiveRecord models
│   ├── queries/          # Complex database queries
│   └── views/            # View templates
├── config/               # Rails configuration files
├── db/                   # Database files and migrations
└── spec/                # RSpec test files
```

## Development Setup

1. Clone the repository:
   ```bash
   git clone [repository-url]
   ```

2. Copy environment file:
   ```bash
   cp .env.dev.example .env.dev
   ```

3. Start the development environment:
   ```bash
   docker-compose -f docker-compose.dev.yml up
   ```

4. Start Tailwind CSS watcher (in a new terminal):
   ```bash
   # Attach to the container and start Tailwind watcher
   docker-compose exec app bin/rails tailwindcss:watch
   ```
   This is required for style updates to be reflected in development.

## Production Deployment

1. Environment Setup:
   ```bash
   # Copy the environment file
   cp .env.example .env
   
   # Edit the environment variables
   nano .env
   ```

2. Required Environment Variables:
   ```plaintext
   # AWS Configuration
   AWS_ACCESS_KEY_ID=your_aws_key
   AWS_SECRET_ACCESS_KEY=your_aws_secret
   AWS_REGION=your_aws_region
   S3_BUCKET_NAME=your_bucket_name

   # Database Configuration
   POSTGRES_USER=your_db_user
   POSTGRES_PASSWORD=your_db_password
   POSTGRES_DB=your_db_name
   DATABASE_URL=postgresql://user:password@db:5432/dbname

   # Rails Configuration
   RAILS_ENV=production
   SECRET_KEY_BASE=your_secret_key_base
   ```

3. Start the Application:
   ```bash
   # Start all services (this will also setup the database)
   docker-compose up -d
   ```

## Available Commands

### Docker Commands

```bash
# Start production environment
docker-compose up -d

# View logs
docker-compose logs -f

# Run Rails console
docker-compose exec app rails c

# Stop all services
docker-compose down

# Attach to container for debugging
docker attach bosba-container

# Execute commands in container
docker-compose exec app bash

#Run Rspec
docker exec -it bosba-app bundle exec rspec
```

## AWS S3 Setup

1. Create an S3 bucket in your AWS account
2. Configure bucket permissions for file uploads
3. Update the following environment variables:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
   - `S3_BUCKET_NAME`

## Security Notes

1. Keep your `.env` file secure and never commit it to version control
2. Regularly update dependencies for security patches
3. Monitor AWS S3 access logs
4. Use strong database passwords
5. Keep your `RAILS_MASTER_KEY` secure

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

Copyright (c) 2024 Bosba Clinique. All rights reserved.

This software and its documentation are proprietary and confidential. 
Unauthorized copying, transferring, or reproduction of this software, its source code, or documentation, via any medium, is strictly prohibited.

The receipt or possession of this software and/or its source code does not convey or imply any right to use it 
for any purpose other than the operation of the software as intended by Bosba Clinique.

All rights are reserved. No part of this software may be reproduced, distributed, or transmitted in any form or by any means 
without the prior written permission of Bosba Clinique.
