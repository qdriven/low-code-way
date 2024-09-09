## Create Upload File Page

创建上传Excel文件页面,只需要一个JAVA类就可以做到:


```java

@Erupt(name = "测试相关文件上传同步", orderBy = "SyncFileEntity.createTime desc")
@Table(name = "uploaded_files")
@Entity
@Data
public class UploadFileModel extends MetaModel {

    @EruptField(
            views = @View(title = "用途"),
            edit = @Edit(
                    search = @Search,
                    title = "获取可选类型",
                    type = EditType.CHOICE,
                    desc = "动态获取可选类型",
                    notNull = true,
                    choiceType = @ChoiceType(
                            fetchHandler = SqlChoiceFetchHandler.class,
                            fetchHandlerParams = "select distinct key,name from master_data where category_code='UPLOAD_FILE_USAGE' and valid=true"
                    ))
    )
    private String usage;


    @EruptField(
            views = @View(title = "文件上传"),
            edit = @Edit(title = "文件上传", type = EditType.ATTACHMENT,
                    attachmentType = @AttachmentType(size = 100000))
    )
    private String attachment;

    @EruptField(
            views = @View(
                    title = "用途描述"
            ),
            edit = @Edit(
                    title = "用途描述",
                    type = EditType.TEXTAREA, notNull = true,
                    inputType = @InputType
            )
    )
    private String comments;
}


```

## 菜单设置

![](./2023-09-25-11-33-00.png)
![](2023-09-25-11-34-38.png)

- [](https://fontawesome.com/v4/icon/file)

![](2023-09-25-11-35-08.png)
![](2023-09-25-11-44-57.png)
![](2023-09-25-11-50-30.png)