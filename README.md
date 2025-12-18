# CUBI12 - API
API RESTful used as backend for Cubi12 software using .NET 7 and PostgreSQL.

Cubi12 is (currently) an open source project to help students at UCN (Universidad Católica del Norte) at Chile to understand all the subjects they can take and their progress in the career.

## Prerequisites

- SDK [.NET 7](https://dotnet.microsoft.com/es-es/download/dotnet/7.0) or higher
- Port 80 Available
- git [2.33.0](https://git-scm.com/downloads) or higher
- [Docker](https://www.docker.com/) **Note**: If you do not have installed is highly recommended to see the steps to correctly install docker on your machine with [Linux](https://docs.docker.com/desktop/install/linux-install/), [Windows](https://docs.docker.com/desktop/install/windows-install/) or [MacOs](https://docs.docker.com/desktop/install/mac-install/)
- [Entity Framework Core Tools](https://learn.microsoft.com/en-us/ef/core/cli/dotnet) (for migrations)

## Getting Started

Follow these steps to get the project up and running on your local machine:

1. Clone the repository to your local machine.

2. Navigate to the root folder.
   ```bash
   cd Backend
   ```

3. Inside the project you will see 2 folders: Cubitwelve and Cubitwelve.tests, navigate to the first.
    ```bash
    cd Cubitwelve
    ```

4. Inside the folder Cubitwelve create a file and call it `.env` then fill with the following example values.
    ```bash
    POSTGRES_PASSWORD=MyStrongPassword123@
    JWT_SECRET=secret_only_knewed_by_yourself_and_nobody_else
    DB_CONNECTION=Host=localhost;Port=5433;Database=master;Username=sa;Password=MyStrongPassword123@;
    ```
    **Note1:** If you decide to change `POSTGRES_PASSWORD` make sure it's a strong password
    
    **Note2:** If you change `POSTGRES_PASSWORD` you also need to update the `DB_CONNECTION` to match the Password parameter in the connection string
    
    **Note3**: If you change `JWT_SECRET` review [Padding](https://www.rfc-editor.org/rfc/rfc4868#page-5) of HmacSha256 Algorithm to avoid Runtime exceptions because of short secret

5. Install project dependencies using dotnet sdk.
   ```bash
   dotnet restore
   ```

6. Setup the PostgreSQL database container. Because the compose file has the name **dev-postgres.yml**, the command needs to include the `--file` flag.
    ```bash
    cd ..  # Go back to Backend folder
    docker-compose --file dev-postgres.yml up -d
    ```

7. Apply database migrations. Navigate back to Cubitwelve folder and run:
    ```bash
    cd Cubitwelve
    dotnet ef database update
    ```
    
    This will create all the necessary tables and apply the database schema.

8. It is recommended to wait 5 seconds after applying migrations, then run the project. This ensures the database is ready before the backend tries to seed data.

    The backend will automatically seed initial data on first run.
    ```bash
    dotnet run
    ```

This will start the development server, and you can access the app in your web browser by visiting http://localhost:80.

## Use

To see the endpoints you can access to OpenAPI Swagger documentation at http://localhost:80/swagger/index.html

Also you can use [Postman](https://www.postman.com/) or another software to use the API.

## Database Technology

The project now uses **PostgreSQL 15** instead of SQL Server for the following reasons:
- Open source and free
- Better cloud deployment compatibility
- Excellent support for modern features
- Cost-effective for production environments

## Database Persistence

The database container **has a volume assigned** (`postgres_data`), which means:
- Data persists between container restarts
- You can safely stop and start the container without losing data
- To completely reset the database, you need to remove the volume:
  ```bash
  docker-compose --file dev-postgres.yml down -v
  ```

## Entity Framework Migrations

When you make changes to the database models, you need to create and apply migrations:

1. Create a new migration:
   ```bash
   cd Cubitwelve
   dotnet ef migrations add MigrationName
   ```

2. Apply the migration to the database:
   ```bash
   dotnet ef database update
   ```

3. Remove last migration (if needed):
   ```bash
   dotnet ef migrations remove
   ```

## Testing

The project uses [xUnit](https://xunit.net/) as testing framework and [FluentAssertions](https://fluentassertions.com/) to improve readability. To run all the tests, run the following commands:

1. If you are inside *Cubitwelve* folder, go to root folder
    ```bash
    # Only if you are inside Cubitwelve folder
    cd ..
    ```
2. Now you are on the root folder, run the tests
    ```bash
    dotnet test
    ```

## Troubleshooting

### Database Connection Issues

If you encounter database connection errors:
1. Verify PostgreSQL is running: `docker ps | grep postgres`
2. Check your `.env` file has the correct connection string
3. Ensure port 5433 is not being used by another application

### DateTime Issues

If you see errors related to `DateTime with Kind=Local`, the project uses `Npgsql.EnableLegacyTimestampBehavior` to handle timezone conversions. This is configured in `Program.cs`.

### Migration Issues

If migrations fail:
1. Ensure the database is running
2. Check that Entity Framework tools are installed: `dotnet ef --version`
3. Try removing the last migration and recreating it

## Docker Compose Files

The project includes two compose files:
- `dev.yml`: **Legacy** - SQL Server configuration (deprecated)
- `dev-postgres.yml`: **Current** - PostgreSQL configuration (use this one)

## Production Deployment

For production deployment instructions, including CI/CD setup and Render configuration, please refer to the deployment documentation.