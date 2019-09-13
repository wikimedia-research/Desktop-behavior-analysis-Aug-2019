
SELECT 
  COUNT(DISTINCT CONCAT(client_ip, user_agent)) as n_user,
  logged_in,
  sidebar_name
FROM (
  SELECT 
  client_ip,
  user_agent,
  IF(x_analytics_map['loggedIn'] = '1', true, false) as logged_in,
  (CASE
    WHEN uri_query LIKE '%&action=info%' THEN 'PageInformation' 
    WHEN pageview_info['page_title'] LIKE '%Special:WhatLinksHere%' THEN 'WhatLinksHere' 
    WHEN pageview_info['page_title'] LIKE '%Special:RecentChangesLinked%' THEN 'RelatedChanges' 
    ELSE pageview_info['page_title'] 
  END) as sidebar_name
FROM wmf.webrequest TABLESAMPLE(BUCKET 1 OUT OF 1024 ON hostname, sequence)
WHERE
year = 2019 and month = 7 
  AND agent_type = 'user'
  AND access_method = 'desktop'
  AND referer_class = 'internal' --isolate to only views to these pages from within wikipedia. 
  AND is_pageview
  AND webrequest_source = 'text'
  AND pageview_info['project'] = 'en.wikipedia'
  AND (pageview_info['page_title'] IN ('Main_Page', 'Portal:Contents', 'Portal:Featured_content', 'Portal:Current_events',
  'Special:Random', 'Help:Contents', 'Wikipedia:About', 'Wikipedia:Community_portal', 'Special:RecentChanges', 'Wikipedia:Contact_us',
  'Wikipedia:File_Upload_Wizard', 'Special:SpecialPages', 'Special:CiteThisPage', 'Special:Book', 'Special:ElectronPdf') OR
      pageview_info['page_title'] LIKE '%Special:WhatLinksHere%' OR 
      pageview_info['page_title'] LIKE '%Special:RecentChangesLinked%' OR 
      pageview_info['page_title'] LIKE '%Special:RecentChangesLinked%' OR 
      uri_query LIKE '%&action=info%')
) AS page_info
Group BY sidebar_name, logged_in