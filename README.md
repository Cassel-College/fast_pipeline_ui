# Fast Pipeline App

## 项目简介

Fast Pipeline App 是一个基于 Flutter 开发的移动应用程序，专门用于管理和监控复杂的任务管道（pipeline）。该应用为用户提供了直观的界面，以查看任务详情、监控步骤状态，并深入了解每个步骤的具体信息。

## 功能特性

- 任务列表展示：概览所有进行中和已完成的任务
- 任务详情页面：
    - 步骤状态概览：使用圆形指示器直观显示每个步骤的状态
    - 交互式步骤导航栏：轻松切换不同步骤
    - 详细的步骤信息展示：包括脚本路径、输入输出文件位置等
- 实时数据更新：通过API实时获取最新的任务状态
- 错误处理和状态管理：确保应用在各种情况下的稳定性

## 技术栈

- Flutter: 用于构建跨平台移动应用
- Dart: 应用程序的主要编程语言
- HTTP package: 处理与后端API的通信
- JSON serialization: 用于数据解析和处理
- 状态管理: 使用 setState 进行本地状态管理

## 快速启动（使用 Docker Hub 镜像）

我们提供了预构建的 Docker 镜像，您可以直接从 Docker Hub 拉取并运行，无需本地构建。这是最快速的启动方式。

### 前提条件

- 安装 [Docker](https://docs.docker.com/get-docker/)

### 步骤

1. 拉取 Docker 镜像：

   ```
   docker pull liupeng0/fast_pipeline_app:latest
   ```

2. 运行 Docker 容器：

   ```
   docker run -d -p 80:80 -p 8000:8000 --name fast_pipeline_container liupeng0/fast_pipeline_app:latest
   ```

   这个命令会：
    - 在后台运行容器（`-d`）
    - 将主机的 80 端口映射到容器的 80 端口（用于 Nginx 服务 Flutter Web 内容）
    - 将主机的 8000 端口映射到容器的 8000 端口（用于 FastAPI 后端）
    - 给容器命名为 `fast_pipeline_container`

### 访问应用

- 前端：在浏览器中访问 `http://localhost`
- 后端 API：可以通过 `http://localhost:8000` 访问

### 停止和删除容器

如果您需要停止并删除容器，可以使用以下命令：

```shell
docker stop fast_pipeline_container
docker rm fast_pipeline_container
```


### 更新到最新版本

要更新到最新版本的镜像，请执行以下步骤：

1. 停止并删除现有容器（如上所示）
2. 拉取最新镜像：

   ```
   docker pull liupeng0/fast_pipeline_app:latest
   ```

3. 使用新镜像重新运行容器（如步骤 2 所示）

### 注意事项

- 确保端口 80 和 8000 在您的主机上没有被其他服务占用。
- 如果您在 Linux 系统上遇到权限问题，可能需要使用 `sudo` 运行 Docker 命令。

### 故障排除

- 如果应用无法访问，请检查防火墙设置，确保允许这些端口的流量。
- 使用 `docker logs fast_pipeline_container` 查看容器日志以排查问题。
- 如果需要进入容器进行调试，可以使用：
  ```
  docker exec -it fast_pipeline_container /bin/bash
  ```

### 自定义配置（可选）

如果您需要自定义某些配置，可以在运行容器时使用环境变量或挂载配置文件。例如：

```shell
docker run -d -p 80:80 -p 8000:8000 \
-e SOME_ENV_VAR=value \
-v /path/to/custom/config:/app/config \
--name fast_pipeline_container liupeng0/fast_pipeline_app:latest
```

请参考项目文档了解可用的环境变量和配置选项。

## 安装

1. 确保您的开发环境中已安装 Flutter。如果没有，请参考 [Flutter 官方文档](https://flutter.dev/docs/get-started/install) 进行安装。

2. 克隆仓库：

   ```
   git clone https://github.com/liupeng0/fast_pipeline_app.git
   ```

3. 进入项目目录：

   ```
   cd fast_pipeline_app
   ```

4. 安装依赖：

   ```
   flutter pub get
   ```

5. 运行应用：

   ```
   flutter run
   ```

## 使用说明

1. 启动应用后，您将看到任务列表。
2. 点击任何任务以查看其详细信息。
3. 在任务详情页面：
    - 顶部圆形指示器展示每个步骤的状态（绿色表示成功，红色表示失败）
    - 使用左侧导航栏在不同步骤之间切换
    - 主区域显示选定步骤的详细信息，包括脚本路径、输入输出文件位置等
4. 使用顶部刷新按钮更新任务数据

## 项目结构

主要文件和目录：

- `lib/`
    - `main.dart`: 应用程序的入口点
    - `task_detail_page.dart`: 任务详情页面的实现，包含状态管理和UI构建
    - `http_tools.dart`: 封装HTTP请求处理的工具类


## 使用 Docker 部署

本项目支持使用 Docker 进行部署，集成了 Flutter Web 前端和 FastAPI 后端。以下是使用 Docker 部署此项目的步骤：

### 前提条件

- 安装 [Docker](https://docs.docker.com/get-docker/)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/) (可选，但推荐)

### 步骤

1. 克隆仓库（如果还没有）：

   ```
   git clone https://github.com/liupeng0/fast_pipeline_app.git
   cd fast_pipeline_app
   ```

2. 构建 Flutter Web 项目：

   ```
   flutter build web
   ```

3. 确保你有一个名为 `nginx.conf` 的 Nginx 配置文件在项目根目录中。

4. 创建 Docker 镜像：

   ```
   docker build -t fast_pipeline_app .
   ```

5. 运行 Docker 容器：

   ```
   docker run -d -p 80:80 -p 8000:8000 --name fast_pipeline_container fast_pipeline_app
   ```

   这将启动一个容器，将主机的 80 端口映射到容器的 80 端口（用于 Nginx 服务 Flutter Web 内容），8000 端口映射到容器的 8000 端口（用于 FastAPI 后端）。


# 贡献

我们欢迎并感谢任何形式的贡献！如果您想为 Fast Pipeline App 做出贡献，请遵循以下步骤：

1. Fork 这个仓库
2. 创建您的特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
4. 将您的更改推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启一个 Pull Request

## 许可证

本项目采用 MIT 许可证。详情请见 [LICENSE](LICENSE) 文件。

## 联系方式

刘鹏 - liupeng.0@outlook.com

项目链接: [fast_pipeline_app](https://github.com/liupengzhouyi/fast_pipeline_app)

## 致谢

- 感谢所有为这个项目做出贡献的开发者
- Flutter 团队提供的出色框架
- 所有提供反馈和建议的用户
