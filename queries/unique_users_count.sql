--estimate of unique users in Jul 2019. These are user who click both internal and external links.
 
SELECT COUNT(DISTINCT CONCAT(client_ip, user_agent)) as n_user,
logged_in
FROM (
SELECT 
client_ip,
user_agent,
IF(x_analytics_map['loggedIn'] = '1', true, false) as logged_in
FROM wmf.webrequest TABLESAMPLE(BUCKET 1 OUT OF 1024 ON hostname, sequence)
WHERE year = 2019 and month = 7
  AND agent_type = 'user'
  AND access_method = 'desktop'
  AND is_pageview
  AND webrequest_source = 'text'
 AND pageview_info['project'] = 'en.wikipedia'
) as dataset
GROUP BY logged_in