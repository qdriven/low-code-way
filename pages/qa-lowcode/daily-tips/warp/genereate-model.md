# Generate Model

![](./2023-09-20-22-41-35.png)

```sh
## Warp AI Transcript (09/20/23 10:42 PM)

Prompt: 根据一下SQL 生成python pydantic 的model，sql： create table master_data
(
    id            bigint not null
        primary key,
    create_by     varchar(255),
    create_time   timestamp,
    update_by     varchar(255),
    update_time   timestamp,
    valid         boolean,
    category_code varchar(255),
    detail        varchar(255),
    key           varchar(255),
    name          varchar(255)
);

Warp AI: 你可以使用以下代码生成Python Pydantic模型：

```python
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class MasterData(BaseModel):
    id: int
    create_by: Optional[str]
    create_time: Optional[datetime]
    update_by: Optional[str]
    update_time: Optional[datetime]
    valid: Optional[bool]
    category_code: Optional[str]
    detail: Optional[str]
    key: Optional[str]
    name: Optional[str]
```

这个模型使用了`pydantic.BaseModel`作为基类，并定义了与SQL表中的列对应的属性。`Optional`表示这些属性可以为空。
```