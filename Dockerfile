FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /App

# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /App
COPY --from=build /App/out .
# Specify the entry point for the application
ENTRYPOINT ["dotnet", "Cubitwelve.dll"]
