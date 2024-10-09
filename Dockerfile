# Use the official Microsoft .NET SDK image (6.0) to build the app
# This image includes the SDK required to build .NET 6 applications
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project file(s) and restore any dependencies required for the application
COPY MvcApp/*.csproj ./
RUN dotnet restore

# Copy the rest of the application files
COPY . .

# Build the application in Release mode
RUN dotnet publish -c Release -o /out

# Use the official .NET runtime image for running the app in production
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Set the working directory in the runtime container
WORKDIR /app

# Copy the output from the build stage to the runtime container
COPY --from=build /out .

# Expose the port that the application listens on
EXPOSE 80

# Define the entry point for the application
ENTRYPOINT ["dotnet", "MvcApp.dll"]
