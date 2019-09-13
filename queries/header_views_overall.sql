
SELECT 
-- pages available to logged out
SUM(IF(page_title = 'Special:MyTalk', 1, null)) AS MyTalk,
SUM(IF(page_title = 'Special:MyContributions', 1, null)) AS MyContributions,
SUM(IF(page_title = 'Special:CreateAccount', 1, null)) AS CreateAccount,
SUM(IF(page_title = 'Special:UserLogin', 1, null)) AS UserLogin,
SUM(IF(page_title LIKE 'User:%', 1, null)) AS UserPage,
SUM(IF(page_title LIKE 'User_talk:%', 1, null)) AS User_talk,
SUM(IF(page_title LIKE 'User:%/sandbox', 1, null)) AS Sandbox,
SUM(IF(page_title = 'Special:Preferences', 1, null)) AS Preferences,
SUM(IF(page_title = 'Special:Watchlist', 1, null)) AS Watchlist,
SUM(IF(page_title LIKE 'Special:Contributions%', 1, null)) AS Contributions,
SUM(IF(page_title = 'Special:UserLogout', 1, null)) AS UserLogout
FROM wmf.pageview_hourly
WHERE year = 2019 and month = 7 
  AND agent_type = 'user'
  AND project = 'en.wikipedia'
  AND access_method = 'desktop'
  AND referer_class = 'internal' --isolate to only views to these pages from within wikipedia. 
