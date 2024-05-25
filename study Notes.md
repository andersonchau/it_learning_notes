# IT Learning Notes

# Web Development

### Redirect (HTTP 302) 
- Backend tell frontend to go to another URL
- Can be set in API endpoint, Apache HTTPD 
- Used in OAuth2, redirection to 

### URL Rewriting 
- purely done in backend 
- can be set in Apache HTTPD, JBOSS

### HTTP 401(Forbiddened) vs 403 (UnAuthorized)
- 401 : Server don't recognize you. Frontend handling : logout, clear cache, back to main page 
- 403 : Server recognize you , but not enough rights to access resources, FE handling : display forbiddened (or not enough access right)


### OAuth2 Single-Sign-On flow (Assume we are developing ABC application)

<ol>
  <li>Setup Phase</li>
  <ul>
	<li>Obtain Client ID, Scope, Client Secret </li>
  </ul>
  <li>SSO Login Flow</li>
  <ol>
	<li>ABC Client (e.g. REACT) access ABC application's protected resources</li>
	<li>ABC App return 302 to ask ABC client to redirect to SSO Server (response Data to ABC Client: (i) SSO Server Authen Endpoint URL (ii) clilentId such that SSO Server knows which App the user is trying to login}/(iii)Scope), the client also add (iv) redirect_URI(*) which is the return point of page of REACT code</li>	
	<li>ABC Client display SSO Server Login Page (e.g. Google Login)and user input Login </li>
	<li>If the login is successful, ABC client receive Authorization Code from SSO Server</li>
	<li>ABC Client send back AuthCode to ABC Server's login endpoint(e.g. which trigger Spring Security's Authentication Provider)</li>
	<li>ABC Server use AuthCode to obtain access token and redirect_uri </li>
	<li>ABC Server send back access token ( or create Token which maps to access token ) for later resource access with HTTP code 302 to ask ABC client to get to redirect_uri</li>
    </ol>
</ol>

### Message Queue 

### Object storage 

### Remote SSH's Authentication (Useful for CI/CD)



 





