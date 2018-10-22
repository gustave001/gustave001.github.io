---
title: Servlet工具类
tags: [java,Servlet]
categories: 实用工具
date: 2018-10-22 22:37:55
---
# HttpServletUtils
```java
import org.apache.commons.lang3.StringUtils;
import javax.servlet.http.HttpServletRequest;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

/**
 * @Author: Gustave
 * @Date: 2018/8/9 17:47
 * @Description:
 */
public class HttpServletUtils {
                    /**
                     * 获取完整请求路径，带请求参数
                     *
                     * @param request
                     * @return
                     */
                    public static String getFullPath(HttpServletRequest request) {
                        StringBuffer uri = request.getRequestURL();
                        String url = uri.toString();
                        // 获取所有请求,返回 Map 集合
                        Map<String, String[]> map = request.getParameterMap();
                        Set<Map.Entry<String, String[]>> entry = map.entrySet();
                        Iterator<Map.Entry<String, String[]>> iterator = entry.iterator();
                
                        // 遍历集合
                        StringBuffer sb = new StringBuffer();
                        while (iterator.hasNext()) {
                            Map.Entry<String, String[]> item = iterator.next();
                            //请求名
                            String key = item.getKey();
                            //请求值
                            for (String value : item.getValue()) {
                                // 拼接每个请求参数 key=value&
                                sb.append(key + "=" + value + "&");
                            }
                        }
                
                        String string = sb.toString();
                        // 拼接 URL, URL?key=value&key=value& 并且去掉最后一个 &
                        if(StringUtils.isNotBlank(string)){
                            url = url + "?" + string.substring(0, string.lastIndexOf("&"));
                        }
                        return url;
                    }
                }

```