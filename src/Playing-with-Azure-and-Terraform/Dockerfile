#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Playing-with-Azure-and-Terraform/Playing-with-Azure-and-Terraform.csproj", "Playing-with-Azure-and-Terraform/"]
RUN dotnet restore "Playing-with-Azure-and-Terraform/Playing-with-Azure-and-Terraform.csproj"
COPY . .
WORKDIR "/src/Playing-with-Azure-and-Terraform"
RUN dotnet build "Playing-with-Azure-and-Terraform.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Playing-with-Azure-and-Terraform.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Playing-with-Azure-and-Terraform.dll"]