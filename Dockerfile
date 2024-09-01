# 基于现有的后端镜像
FROM fast_pipeline_server:latest AS fast_pipeline_server_with_nginx

# 安装 Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制本地 Flutter Web 静态文件到 Nginx 默认目录
COPY build/web /usr/share/nginx/html

# 复制自定义 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80 8000

# 启动 Nginx 和 FastAPI 后端
CMD ["sh", "-c", "nginx && uvicorn main:app --host 0.0.0.0 --port 8000 --reload"]
