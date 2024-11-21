# Usar una imagen base de Node.js
FROM node:16-alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Copiar los archivos de configuración
COPY package.json package-lock.json ./

# Instalar las dependencias
RUN npm install

# Copiar el resto del código de la aplicación
COPY . .

# Generar el cliente de Prisma
RUN npx prisma generate

# Exponer el puerto 3000
EXPOSE 3000
