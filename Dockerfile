FROM node:18-slim AS builder
WORKDIR /app
COPY . ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build

FROM node:18-slim AS runtime
WORKDIR /app
ENV NODE_ENV=production
RUN useradd -m app && chown -R app:app /app
COPY --from=builder /app/dist ./dist
RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3
CMD curl -f http://localhost:8000/health || exit 1
CMD ["yarn", "start"]