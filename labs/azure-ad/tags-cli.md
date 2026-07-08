# TAGS CLI

```bash
# search tag on your subscription/resource group
$ az tag -h

Group
    az tag : Tag Management on a resource.

Commands:
    add-value    : Create a tag value.
    create       : Create tags on a specific resource.
    delete       : Delete tags on a specific resource.
    list         : List the entire set of tags on a specific resource.
    remove-value : Deletes a predefined tag value for a predefined tag name.
    update       : Selectively update the set of tags on a specific resource.

For more specific examples, use: az find "az tag"
```

```bash
az tag list --query [].tagName

[
    "ms-resource-usage",
    "CostCenter",
    "Dept",
    "LifeCyclePhase",
    "Project",
    "ProjectManager"
]
```