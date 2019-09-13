SELECT 
SUM(IF((pageview_info['page_title'] = 'Main_Page'), 1, null)) AS main_page,
  SUM(IF((pageview_info['page_title'] = 'Portal:Contents'), 1, null)) AS contents,
  SUM(IF((pageview_info['page_title'] = 'Portal:Featured_content'), 1, null)) AS featured_content,
  SUM(IF((pageview_info['page_title'] = 'Portal:Current_events'), 1, null)) AS current_events,
  SUM(IF((pageview_info['page_title'] = 'Special:Random'), 1, null)) AS random_article,
  SUM(IF((pageview_info['page_title'] = 'Help:Contents'), 1, null)) AS help_views,
  SUM(IF((pageview_info['page_title'] = 'Wikipedia:About'), 1, null)) AS about_wikipedia,
  SUM(IF((pageview_info['page_title'] = 'Wikipedia:Community_portal'), 1, null)) AS community_portal,
  SUM(IF((pageview_info['page_title'] = 'Special:RecentChanges'), 1, null)) AS recent_changes,
  SUM(IF((pageview_info['page_title']= 'Wikipedia:Contact_us'), 1, null)) AS contact_page,
  SUM(IF((pageview_info['page_title'] LIKE '%Special:WhatLinksHere%'), 1, null)) AS what_links_here,
  SUM(IF((pageview_info['page_title'] LIKE '%Special:RecentChangesLinked%'), 1, null)) AS related_changes,
  SUM(IF((pageview_info['page_title'] = 'Wikipedia:File_Upload_Wizard'), 1, null)) AS file_upload,
  SUM(IF((pageview_info['page_title'] = 'Special:SpecialPages'), 1, null)) AS special_pages,
  SUM(IF((uri_query LIKE '%&action=info%'), 1, null)) AS page_info,
  SUM(IF((pageview_info['page_title'] = 'Special:CiteThisPage'), 1, null)) AS cite_this_page, 
  SUM(IF((pageview_info['page_title'] = 'Special:Book'), 1, null)) AS create_book,
  SUM(IF((pageview_info['page_title'] = 'Special:ElectronPdf'), 1, null)) AS download_as_pdf
FROM wmf.webrequest
WHERE year = 2019 and month = 7
  AND agent_type = 'user'
  AND pageview_info['project'] = 'en.wikipedia'
  AND access_method = 'desktop'
  AND referer_class = 'internal' 
  AND is_pageview--isolate to only views to these pages from within wikipedia. 