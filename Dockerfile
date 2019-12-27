# 基础镜像
FROM node:10.16-alpine as builder

# 拷贝静态资源文件
COPY . /app/

# 工作目录
WORKDIR /app

# 运行命令
#RUN npm install
RUN yarn config set registry https://registry.npm.taobao.org \
  && yarn config set sass-binary-site http://npm.taobao.org/mirrors/node-sass \
  && yarn install
# RUN yarn add puppeteer
RUN yarn build
