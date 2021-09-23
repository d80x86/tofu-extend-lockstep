## tofu-extend-lockstep

lockstep extend of tofu

很多业务都是有序的，或必须当某个业务完成后才能执行下一个业务。这时我们就需要在多个worker工作模式下，进行同步执行某个业务，确保业务的有序性。



### 安装

```lua
-- 在项目配置文件 tofu.package.lua 添加

deps = {

  --
  -- 其它配置 ...
  --

  'd80x86/tofu-extend.lockstep',
}

```



### 使用tofu安装

```sh
./tofu install
```



### 使用配置

```lua
-- 项目配置文件 conf/extend.lua

extend = {

  -- 添加同步执行扩展组件
  {
    named = 'lockstep',
    default = {
      handle = 'resty.tofu.extend.lockstep',
      options = {}
    }
  }

}

```




### 配置options

| 参数名  | 类型   | 说明                | 缺省               |
| ------- | ------ | ------------------- | ------------------ |
| timeout | float  | 锁定超时时长(秒)    | 5                  |
| shm     | string | ngx.share.DICT 名称 | tofu_lockstep_dict |



### Lua API

**tofu.lockstep(key, fun [, ...args])**

以key为原子锁，直到 fun 函数执行完后自动释放锁。return fun(...args)

* `key` string 键名称
* `fun` function 函数
* `...args` any fun 函数的参数

使用样例

``` lua
local key = 'printer'
local fun = function (user_id)
    			-- ... 业务处理
    		 end
tofu.lockstep(key, fun, user_id)

```


