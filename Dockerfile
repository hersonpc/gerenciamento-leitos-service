FROM node:10

LABEL maintainer="Herson Melo <hersonpc@gmail.com>"

USER root
  
WORKDIR "/app"

COPY ./bin /app

RUN chmod +x /app/run.sh && \
  chmod +x /app/gth_data_extractor

EXPOSE 3000

CMD [ "/app/run.sh" ]