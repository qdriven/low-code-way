#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import re
import subprocess



input_lines = sys.stdin.readlines()

print "Content"
print input_lines

# Check all commits, skiping tags
all_ok = True
def check_lines(lines):
    new_lines = []
    for line in lines:
        line = line.replace("\n", "")
        if len(line) > 0:
            new_lines.append(line)
    has_task_id = False
    valid_first_line_msg = False
    for idx in range(len(new_lines)):
        if new_lines[idx].startswith("Author"):
            task_id = new_lines[idx + 1].strip()
            if len(task_id) == 23 and int(task_id) > 0:
                has_task_id = True
            else:
                has_task_id = False
            if has_task_id:
                try:
                    first_line_msg = new_lines[idx + 2].strip()
                    if len(first_line_msg) >= 10:
                        valid_first_line_msg = True
                    else:
                        valid_first_line_msg = False
                except Exception:
                    valid_first_line_msg=False
    return has_task_id,valid_first_line_msg

for each_line in input_lines:
    if each_line:
        print
        "Content: " + each_line
        (base, commit, ref) = each_line.strip().split()
        print("base:", base)
        print("commit:", commit)
        print("ref", ref)
        valid_commit_msg = False

        if ref[:9] == "refs/tags":  # Skip tags
            all_ok = True
            continue
        if ref[:13] != "refs/head/dev":  # dev branch 
            all_ok = True
            continue

        new_br_push = re.match(r'[^1-9]+', base)  # handles new branches being pushed
        if new_br_push:
            all_ok = True
            continue
        revs = base + "..." + commit
        proc = subprocess.Popen(['git', 'rev-list', '--pretty=short', '--first-parent', revs], stdout=subprocess.PIPE)
        lines = proc.stdout.readlines()
        print("lines:", lines)
        has_task_id,valid_first_line_msg=check_lines(lines)
        if has_task_id and valid_first_line_msg:
            all_ok = True
            continue
        else:
            all_ok = False
            break

if all_ok:  # or new_branch_push or branch_deleted:
    exit(0)
else:
    print "提交描述规则:1.第一行:任务号(23位数字)必须包括在提交信息中;2.第二行:描述信息不少于10个字符，请看如下示例："
    print "20021199348814587154432"
    print "1.描述a;"
    print "2.描述b;"
    print "3.描述c;"
    print "提示：gitbash可以通过git commit --amend可以修改注释，sourceTree可以使用提交选项-修改最后一次提交。"