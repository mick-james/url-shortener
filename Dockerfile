FROM elixir:1.11.2-alpine

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

# setup container
RUN apk add --update npm
RUN mix local.hex --force
RUN mix local.rebar --force

# Cache elixir deps
ADD shortener_umbrella/mix.exs /stord/
ADD shortener_umbrella/mix.lock /stord/
# shortener app
ADD shortener_umbrella/apps/shortener/mix.exs /stord/apps/shortener/
# shortener web app
ADD shortener_umbrella/apps/shortener_web/mix.exs /stord/apps/shortener_web/
# do build
RUN cd /stord && mix deps.get
RUN cd /stord && mix deps.compile

# Same with npm deps
# ADD shortener_umbrella/apps/shortener_web/assets/package.json apps/shortener_web/assets/
# RUN cd apps/shortener_web/assets && npm install

# Run frontend build, compile, and digest assets
# RUN cd apps/shortener_web/assets/ && \
#   npm run deploy && \
#   cd - && \
#   mix do compile, phx.digest

# USER default

#CMD ["mix", "phx.server"]
CMD ["sh"]