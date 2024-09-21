# IT Learning Notes

# Web Development and Others

### Redirect (HTTP 302) 
- Backend tell frontend to go to another URL by http 302
- Can be set in API endpoint or Apache HTTPD 
```bash
    # Apache HTTPD Example : match.html redirected rewrite.html
	RewriteRule ^match\.html$ rewrite.html [NC,L] 
```
- Used in OAuth2, redirecting back to original page in Application 

### URL Rewriting 
- Purely done in backend , not noticeable by client
- can be set in Apache HTTPD, JBOSS, for example : 

```bash
	# Apache HTTPD Example 
	Proxypass /healthCheckForAppServer http://<app_server_ip>/appName/api/doHealthCheck
	ProxypassReverse /healthCheckAppServer http://<app_server_ip>/appName/api/doHealthCheck
```


### HTTP 401(Forbiddened) vs 403 (UnAuthorized)
- 401 : Server don't recognize you. Frontend handling : logout, clear cache, back to main page 
- 403 : Server recognize you , but not enough rights to access resources, FE handling : display forbiddened (or not enough access right)


### OAuth2 Single-Sign-On flow (Assume we are developing ABC application)

<ol>
  <li>Setup Phase</li>
  <ul>
	<li>Obtain Client ID, Scope, Client Secret from Authentication providers ( e.g. GOOGLE)</li>
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

### Remote SSH's(SCP) PK Authentication (Useful for CI/CD) 
1. Trust Remote Servers by putting remote server's fingerprint (short version of public key)to my known_hosts files: *ssh-keyscan -H <remote_server_IP> >> ~/.ssh/known_hosts* 
2. Create Pri-Pub Key pairs (Cmd : *ssh-keygen -t rsa* (generated 2 files: ~/.ssh/id_rsa (private key) and ~/.ssh/id_rsa.pub (public key), then enter passphrase to encrypt the Private Key ) 
3. Copy Public Key to remote server's authorized_keys files (scp ~/.ssh/id_rsa.pub username@hostName , then cat ~/id_rsa.pub >> ~/.ssh/authorized_keys )
4. cat public_key_file >> ~/.ssh/authorized_keys 
5. Then you can access remote server using scp or ssh to run commmand.

### CAP Theorem 
- C : Consistency, A : Availability , P : Partition Tolerence, CA(dont pratically exist)/AP/CP can exists but not CAP
- P is a condition, A/P is Goal=> Choose Either AP or CP 
- "In a distributed data store, at the time of network partition you have to chose either Consistency or Availability and cannot get both"
- C : Data Consistency for all nodes (all nodes store the recent write)
- P : communcation between nodes is down (network failure, the Cluster is said to be partitioned). 
- A : all request (read/write) return no-error with result/
- CP : System not claimed itself to be not available to write request. (e.g. only allow read read request)
- AP : Every request receives a (non-error) response, without the guarantee that it contains the most recent write. SYNC after network recover.
- CA : only occurr in a non-distributed system - Single Node.


### CORS 
- A scheme to disallow web page calling external site's resources (including APIs)
- When access resources, Server generated : Access-Control-Allow-Origin: https://example.com -> JS in webpage (with Origin: https://example.com) is only allowed to access resources.
- Browser will do checking by comparing  Access-Control-Allow-Origin and Origin, if unmatched -> return 403 
- Access-Control-Allow-Origin: \* , allow resource to be access from other site
- Other controlling headers : Access-Control-Request-Method / Access-Control-Request-Headers
- Extra : Server side should also check the incoming "Origin: xx" header for better security. 


 





