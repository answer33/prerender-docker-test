# 基础镜像
FROM node:12.13.1 as builder

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN apt-get update \
    && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

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
