# README

[cube](https://cube.dev/)Headless Business Intelligence,Access data, organize it, and deliver it to every tool
so you can build powerful, fast, and consistent data applications.

## 安装-Installation

```sh

docker run -p 4000:4000 \
  -v ${PWD}s/conf:/cube/conf \
  -e CUBEJS_DEV_MODE=true \
  cubejs/cube:latest
```

## setup Database

## 实际例子

- API统计
- 测试用例统计
- 测试执行统计
- 成本统计