SELECT 
  COUNT(DISTINCT CONCAT(client_ip, user_agent)) as n_user,
  header_name
FROM (
  SELECT 
  client_ip,
  user_agent,
  (CASE 
    WHEN pageview_info['page_title'] LIKE 'User:%' THEN 'User' 
    WHEN pageview_info['page_title'] LIKE 'User_talk:%' THEN 'User_talk' 
    WHEN pageview_info['page_title'] LIKE 'User:%/sandbox' THEN 'Sandbox' 
    WHEN pageview_info['page_title'] LIKE 'Special:Contributions%' THEN 'Special:Contributions'
    ELSE pageview_info['page_title'] 
  END) as header_name
FROM wmf.webrequest TABLESAMPLE(BUCKET 1 OUT OF 1024 ON hostname, sequence)
WHERE
year = 2019 and month = 7 
  AND agent_type = 'user'
  AND access_method = 'desktop'
  AND referer_class = 'internal' --isolate to only views to these pages from within wikipedia. 
  AND is_pageview
  AND x_analytics_map['loggedIn'] is NOT NULL  
  AND webrequest_source = 'text'
  AND pageview_info['project'] = 'en.wikipedia'
 AND (pageview_info['page_title'] IN ('Special:Preferences', 'Special:Watchlist','Special:UserLogout') 
OR
      pageview_info['page_title'] LIKE 'User:%' OR 
      pageview_info['page_title'] LIKE 'User_talk:%' OR 
      pageview_info['page_title'] LIKE 'User:%/sandbox' OR
      pageview_info['page_title'] LIKE 'Special:Contributions%') 
) AS page_info
Group BY header_name