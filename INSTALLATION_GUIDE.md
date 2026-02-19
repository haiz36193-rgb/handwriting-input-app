# 软件安装完整指南

本指南将指导您完成项目运行所需的所有软件安装。

---

## 📋 安装清单

- [ ] Java 11 (JDK)
- [ ] Maven
- [ ] MySQL 8.0
- [ ] Redis

---

## 1️⃣ 安装 Java 11 (JDK)

### 下载链接

**Oracle JDK 11（官方版，免费）**：
https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html

下载文件：`jdk-11.0.21_windows-x64_bin.exe` (约 160MB)

**或者使用 OpenJDK 11（完全免费开源）**：
https://adoptium.net/temurin/releases/?version=11
下载文件：`Eclipse_Temurin-11.0.21-win_x64.msi`

### 安装步骤

1. **下载**：点击上面的链接，下载安装程序
2. **运行**：双击下载的 `.exe` 或 `.msi` 文件
3. **安装向导**：
   - 点击"下一步"
   - 选择安装路径（默认：`C:\Program Files\Java\jdk-11.0.21\`）
   - 点击"下一步"
   - 等待安装完成
   - 点击"关闭"

### 配置环境变量

1. **打开环境变量设置**：
   - 右键点击"此电脑"（或"我的电脑"）
   - 选择"属性"
   - 点击"高级系统设置"
   - 点击"环境变量"

2. **设置 JAVA_HOME**：
   - 在"系统变量"区域，点击"新建"
   - 变量名：`JAVA_HOME`
   - 变量值：`C:\Program Files\Java\jdk-11.0.21\`
   - 点击"确定"

3. **设置 Path**：
   - 在"系统变量"区域，找到"Path"变量
   - 点击"编辑"
   - 点击"新建"
   - 输入：`%JAVA_HOME%\bin`
   - 点击"确定"保存所有窗口

### 验证安装

打开命令提示符（CMD）：

```bash
# 方法1：按 Win+R，输入 cmd，回车
# 方法2：在开始菜单搜索"cmd"

# 在CMD中输入：
java -version
```

**成功标志**：显示类似以下内容
```
java version "11.0.21" 2023-10-17 LTS
Java(TM) SE Runtime Environment 18.9 (build 11.0.21+9-LTS)
Java HotSpot(TM) 64-Bit Server VM 18.9 (build 11.0.21+9-LTS, mixed mode)
```

如果显示版本号，说明安装成功！

**如果提示"不是内部或外部命令"**：
- 检查环境变量是否配置正确
- 关闭所有CMD窗口，重新打开CMD再次尝试

---

## 2️⃣ 安装 Maven

### 下载链接

https://maven.apache.org/download.cgi

下载文件：`apache-maven-3.9.5-bin.zip` (约 9MB)

### 安装步骤

1. **下载**：点击上面的链接，下载ZIP文件
2. **解压**：
   - 右键点击下载的文件
   - 选择"解压到..."
   - 解压到：`C:\maven\`
   - 解压后的路径应该是：`C:\maven\apache-maven-3.9.5\`

### 配置环境变量

1. **打开环境变量设置**（同Java配置）
2. **设置 MAVEN_HOME**：
   - 在"系统变量"区域，点击"新建"
   - 变量名：`MAVEN_HOME`
   - 变量值：`C:\maven\apache-maven-3.9.5\`
   - 点击"确定"

3. **设置 Path**：
   - 在"系统变量"区域，找到"Path"变量
   - 点击"编辑"
   - 点击"新建"
   - 输入：`%MAVEN_HOME%\bin`
   - 点击"确定"保存所有窗口

### 验证安装

打开新的CMD窗口，输入：

```bash
mvn -version
```

**成功标志**：显示类似以下内容
```
Apache Maven 3.9.5 (57804ffe001d7215b5e0d8cd4f3273d6a2b2a1d0)
Maven home: C:\maven\apache-maven-3.9.5
Java version: 11.0.21, vendor: Oracle Corporation
```

---

## 3️⃣ 安装 MySQL 8.0

### 下载链接

https://dev.mysql.com/downloads/mysql/

下载文件：`mysql-8.0.34-winx64.zip` (约 420MB)

或者下载安装程序（更简单）：
https://dev.mysql.com/downloads/installer/
选择：`mysql-installer-community-8.0.34.0.msi` (约 470MB)

### 方法A：使用安装程序（推荐，简单）

1. **下载**：下载 `mysql-installer-community-8.0.34.0.msi`
2. **运行**：双击 `.msi` 文件
3. **安装类型**：
   - 选择"Developer Default"（开发者默认）
   - 点击"Next"
4. **检查需求**：
   - 点击"Execute"安装所有依赖
   - 等待完成
   - 点击"Next"
5. **配置**：
   - 设置 root 密码（记住这个密码！）：`root`
   - 点击"Next"
   - 点击"Execute"执行配置
   - 等待完成
   - 点击"Finish"

### 方法B：使用ZIP文件（更灵活）

1. **下载**：下载 `mysql-8.0.34-winx64.zip`
2. **解压**：解压到 `C:\mysql-8.0.34\`
3. **创建配置文件**：
   - 在 `C:\mysql-8.0.34\` 创建文件 `my.ini`
   - 内容见下方

**my.ini 配置内容**：
```ini
[mysqld]
basedir=C:\\mysql-8.0.34
datadir=C:\\mysql-8.0.34\\data
port=3306
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
default-authentication-plugin=mysql_native_password

[client]
default-character-set=utf8mb4
```

4. **初始化数据库**（以管理员身份运行CMD）：
```bash
cd C:\mysql-8.0.34\bin
mysqld --initialize-insecure --console
mysqld --install
net start mysql
```

### 创建项目数据库

打开CMD，登录MySQL：

```bash
cd C:\mysql-8.0.34\bin
mysql -u root -p
# 输入密码（如果设置过，直接回车）
```

在MySQL命令行中执行：

```sql
CREATE DATABASE handwriting_input_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 验证安装

```bash
# 在CMD中
mysql -u root -p
# 输入密码后，应该能看到 MySQL 提示符：mysql>
```

---

## 4️⃣ 安装 Redis

### 下载链接

Redis官方不支持Windows，我们需要使用第三方版本：

**Memurai（推荐，Redis的Windows版）**：
https://www.memurai.com/get-memurai
下载：`Memurai-3.0.2.msi` (约 10MB)

**或者使用微软维护的旧版本**：
https://github.com/microsoftarchive/redis/releases
下载：`Redis-x64-3.2.100.zip`

### 安装步骤（使用Memurai MSI安装程序）

1. **下载**：下载 `Memurai-3.0.2.msi`
2. **运行**：双击 `.msi` 文件
3. **安装向导**：
   - 点击"Next"
   - 选择安装路径（默认：`C:\Program Files\Memurai\`）
   - 勾选"Install Memurai as a Windows Service"
   - 设置服务端口：6379
   - 点击"Next"直到完成

### 安装步骤（使用ZIP文件）

1. **下载**：下载 `Redis-x64-3.2.100.zip`
2. **解压**：解压到 `C:\redis\`
3. **启动Redis**：
   - 打开CMD
   - 进入目录：`cd C:\redis`
   - 运行：`redis-server.exe`
   - Redis会以窗口形式运行

**注意**：使用ZIP版本时，Redis窗口不能关闭，关闭后Redis停止运行。

### 验证安装

打开新的CMD窗口：

```bash
cd C:\Program Files\Memurai\  # 或 C:\redis\
redis-cli
# 会看到：127.0.0.1:6379>
ping
# 应该返回：PONG
```

---

## ✅ 完成检查清单

安装完所有软件后，在CMD中依次执行以下命令验证：

```bash
# 检查Java
java -version
# 应该显示：java version "11.0.21"

# 检查Maven
mvn -version
# 应该显示：Apache Maven 3.9.5

# 检查MySQL
mysql -u root -p
# 应该能登录MySQL，显示 mysql> 提示符

# 检查Redis
redis-cli ping
# 应该返回：PONG
```

---

## 🚀 下一步

完成所有软件安装后，请告诉我，我会指导您：

1. 初始化数据库
2. 启动后端服务
3. 测试API接口

---

## ❓ 常见问题

### Q1: Java安装后命令无法识别
**A**: 检查环境变量配置，确保 `%JAVA_HOME%\bin` 已添加到 Path，重启CMD窗口

### Q2: Maven下载速度慢
**A**: 配置国内镜像源，编辑 `C:\maven\apache-maven-3.9.5\conf\settings.xml`，在 `<mirrors>` 节点添加：
```xml
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```

### Q3: MySQL启动失败
**A**:
- 检查3306端口是否被占用：`netstat -ano | findstr :3306`
- 查看MySQL错误日志：`C:\mysql-8.0.34\data\` 目录下的 `.err` 文件

### Q4: Redis无法启动
**A**:
- 检查6379端口是否被占用：`netstat -ano | findstr :6379`
- 使用ZIP版本时，确保 `redis-server.exe` 正在运行

---

## 📞 安装完成后

完成所有安装后，请告诉我：
- "安装完成"

我会立即指导您启动项目！

---

**预计安装时间**：
- Java：15分钟
- Maven：5分钟
- MySQL：20分钟
- Redis：5分钟
- **总计**：约45分钟