SELECT 
  COUNT(DISTINCT CONCAT(client_ip, user_agent)) as n_user,
  sidebar_name
FROM (
  SELECT 
  client_ip,
  user_agent,
  pageview_info['page_title'] as sidebar_name
FROM wmf.webrequest TABLESAMPLE(BUCKET 1 OUT OF 1024 ON hostname, sequence)
WHERE
year = 2019 and month = 7 
  AND agent_type = 'user'
  AND access_method = 'desktop'
  AND referer_class = 'internal' --isolate to only views to these pages from within wikipedia. 
  AND is_pageview
  AND x_analytics_map['loggedIn'] is NULL  
  AND webrequest_source = 'text'
  AND pageview_info['project'] = 'en.wikipedia'
  AND pageview_info['page_title'] IN ('Special:MyTalk', 'Special:MyContributions','Special:CreateAccount','Special:UserLogin') 
) AS page_info
Group BY sidebar_name