# Two-stage  docker container for mermaid-js/mermaid-live-editor
# Build              : docker build -t mermaid-js/mermaid-live-editor .
# Run                : docker run --name mermaid-live-editor --publish 8080:8080 mermaid-js/mermaid-live-editor
# Start              : docker start mermaid-live-editor
# Use webbrowser     : http://localhost:8080
# Stop               : press ctrl + c 
#                                     or 
#                                        docker stop mermaid-live-editor
FROM node:20.3.1 as mermaid-live-editor-builder 
COPY --chown=node:node . /home
WORKDIR /home
RUN yarn install
RUN yarn build

FROM nginxinc/nginx-unprivileged:alpine as mermaid-live-editor-runner
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=mermaid-live-editor-builder --chown=nginx:nginx /home/docs /usr/share/nginx/html
