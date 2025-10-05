# IT System/Software Engineering/Programming/Web Development notes

## Web Development and Others


### General HTTP code 
- 2xx - Generally OK (200) but ( with other 2xx variation ), 3xx - Redireciton , 4xx - Client side reported error , 5xx - Server side reported error
- 401(Forbiddened) : Server don't recognize you. Frontend handling : logout, clear cache, back to main page 
- 403(UnAuthorized) : Server recognize you , but not enough rights to access resources, FE handling : display forbiddened (or not enough access right)

### Redirect (HTTP 302) 
- Backend tell frontend to go to another URL by http 302
- Can be set in API endpoint or Apache HTTPD 
```bash
    # Apache HTTPD Example : match.html redirected rewrite.html
	RewriteRule ^match\.html$ rewrite.html [NC,L] 
```
- Used in OAuth2, redirecting back to original page in Application 
- Used in HTTP to HTTPS redirection
- Used in setting up maintenance page 

### URL Rewriting 
- Purely done in backend , not noticeable by client
- can be set in Apache HTTPD, JBOSS, for example : 

```bash
	# Apache HTTPD Example 
	Proxypass /healthCheckForAppServer http://<app_server_ip>/appName/api/doHealthCheck
	ProxypassReverse /healthCheckAppServer http://<app_server_ip>/appName/api/doHealthCheck
```




### Caching (with HTTP headers) 
- Expires: <DateTime> , tell client browser the resource will be expired after <DateTime>, client should make the real HTTP request afterwards  
- Cache-Control: max-age=30, differential, resource expires after 30 seconds , override Expires
- Update Method 1 : eTag : when resource going to expire , browser send GET resource with <If-None-Match> <eTag value> , server return 304 (not modified) , if not return actual resource
- Update Method 2 : Server return <Last Modified> <DT> , Client send <If-Modified-Since> <DT> -> server return 304 or actual content.
- M2 is slightly better than 1 because if server resource has it Last modified time updated but no content update => content is sent by M2 but not M1
- Cache-Control: no-cache : to ask for any fresh copy for each request. 
- Notice the header adding sequence : WAF/Web Server/Application Server/Application

### Caching for SPA(React, Angular , Vue), with rollout concerns 
- To ensure fresh copy are always be retreived.
- use "Cache-Control: no-store" in frontepage (index.html), it means that server ask client "Never store data locally" 
- Every build will create abc.e610b1e12ac232.js , this will enforce pages are not cached after updated. 
- Under HA environment, load balancer stickiness is needed for zero down time 



### Cookie, Local Storage and Session Storage, Server Session. 
- Local Storage : stay even after browser is closed, max 5MB, unless explicitly cleared , not suitable to store JWT token 
- Session Storage : close after browser tab is closed. 
- If you develop application in HA envrionment, check for session, either Application server (JBoss) support clustered session, or use Stateless token (JWT Token)

### Web Dev Tools
- Mockoon : Recommended for Mock API Server
- Postman : good for client and Mock API Server 
- 




### OAuth2 Single-Sign-On flow (Assume we are developing ABC application)

<ol>
  <li>Setup Phase</li>
  <ul>
	<li>Obtain Client ID, Scope, Client Secret from Authentication providers ( e.g. GOOGLE, Keycloak)</li>
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
1. Trust Remote Servers by putting remote server's fingerprint (short version of public key)to my known_hosts files: *ssh-keyscan -H <remote_server_IP> >> ~/.ssh/known_hosts* ( Purpose : build the trust to remote host here, analogous to inserting SSL cert to truststore) 
2. Create Pri-Pub Key pairs (Cmd : *ssh-keygen -t rsa* (generated 2 files: ~/.ssh/id_rsa (private key) and ~/.ssh/id_rsa.pub (public key), then enter passphrase to encrypt the Private Key ) 
3. Copy Public Key to remote server's authorized_keys files (scp ~/.ssh/id_rsa.pub username@hostName , then cat ~/id_rsa.pub >> ~/.ssh/authorized_keys ) ( Purpose : Let remote server to trust me )
4. cat public_key_file >> ~/.ssh/authorized_keys 
5. Then you can access remote server using scp or ssh to run commmand.

### CAP Theorem 
- C : Consistency, A : Availability , P : Partition Tolerence, CA(dont practically exist)/AP/CP can exists but not CAP
- P is a condition, A/P is Goal=> Choose Either AP or CP 
- "In a distributed data store, at the time of network partition you have to chose either Consistency or Availability and cannot get both"
- C : Data Consistency for all nodes (all nodes store the recent write)
- P : communcation between nodes is down (network failure, the Cluster is said to be partitioned). 
- A : all request (read/write) return no-error with result/
- CP : System not claimed itself to be not available to write request. (e.g. only allow read read request)
- AP : Every request receives a (non-error) response, without the guarantee that it contains the most recent write. SYNC after network recover.
- CA : only occurr in a non-distributed system - Single Node.


### CORS 
- A scheme to disallow web page calling external site's resources using JS (e.g. AJAX) (including APIs) 
- When access resources, Server generated : Access-Control-Allow-Origin: https://example.com -> JS in webpage (with Origin: https://example.com) is only allowed to access resources.
- Browser will check by comparing  Access-Control-Allow-Origin and Origin, if unmatched -> return 403, ( checked and forbiddened by Browser) 
- Access-Control-Allow-Origin: \* , allow resource to be accessed from ALL other sites
- Access-Control-Allow-Origin: https://mysite.com {must match protocol (https), domain name(mysite.com) and port number (443) , allow resource to be accessed mysite.com (Useful when API server serving mysite.com is from another site) 
- Access-Control-Allow-Origin header can be added in Application Server/Web Server.
- Other controlling headers : Access-Control-Request-Method / Access-Control-Request-Headers
- Extra : Server side should also check the incoming "Origin: xx" header for better security. 

### CSRF ( Cross Site Request Forgery )
- Prevention - CSRF Token : A one-time token sent from server to frontend page (probably containing a FORM ), the form POST back CSRF token
- To prevent cross-site access or multiple access by matching server assigned token 
- e.g. In Spring Security , it can insert hidden field in input tag <input type="hidden" name="_csrf" value="4bfd1575-3ad1-4d21-96c7-4ef2d9f86721"/> 

### XSS Attack by Example : 
- Inject JS to victims browsers and execute , to steal victims' data 
- e.g. Phishing Email : https://abc.com/xxx?<Malicious_JS_SCRIPTS> 
- e.g. Save Malicious JS script to server and load the JS to victims PC.( Prevention method : to escape special characters to prevent HTML injection)

### Simple Enrcryption for Programmers 

- SHA256 Hash : for password hashing before saving to DB.  
- MD5 Hash : for checking File Integrity 
- Encryption as Rest : Achieved by Software library , Hardware Drivers.
- Symmetric Secret Key Application Data encryption - AES256, Provided by Spring Crypto library, Apache Common ( Sometimes embedded with Timestamp ) 

### Microservices 


## IT-Products


### IT-Product : Apache HTTPD
- Static content hosting (HTML/CSS/JS) 
- DMZ Face
- URL Rewriting , ( can also based on logics ) {RewriteEngine - RewriteRule} 
- Implement IP Address Ratemeter  (ModSecurity) 
- Monitor HTTP Traffic 
- As Load Balancer 
- Host/Port based Routing to workers ( VirutalHosts)
- Path based Routing to workers , route request to App Server workers/VMs ( ProxyPass/ProxyPassReverse)
- SSL Termination (SSLCertificateFile/SSLCertificateKeyFile/SSLCertificateChainFile)
- Manage Header/Cookie ( CORS , Add security header ) 
- Adding hooks to impelement extra Feature ( LUA + QueueIT ) 
- High performance configuration (Worker thread count , mpm)
- Foward Proxy 

### IT-Product : JBoss 
- Servlet Container ( for Servlet , Angular/React packaged to WAR, Spring Application ) 
- JBoss EAP ( Commercial Version Supported by Redhat ) , JBoss AS (obselete)
- Wildfly (prev. JBoss AS) -- community version of JBoss
- JNDI connection to DB with connection pool 
- SSL Handling 
- Log management
- Undertow HTTP Handler ( work like Tomcat) 
- Extra Enterprise Level Services ( e.g. ActiveMQ,Mail, Caching )  
- HA Mode vs Standalone mode 
- vs Tomcat ( TC is a web container , but JBoss is a J2EE container) 


### IT-Product : Queue-IT 
- Waiting room feature, controlling the ther number of user to enter the protected site per minute (Speed) 
- QUEUE vs Waiting Room Concept : Can have multiple waiting room (e.g. UAT/DEV/PROD ), but share the same QUEUE. Waiting room as logical queue partition. 
- Implementation I (Frontend) : Insert QIT JS in frontpage, ask client to goto QIT-waiting room to wait. => Insecure, User can bypass the checking 
- Implementation II (Backend) : Insert a Interceptor Logic to Public Facing Server. (1) check cookie for QIT token (2) return 302 to Queue Server (3) After waiting -> QIT Server return QIT Token -> 302 back to site  (4) Client present QIT token and enter site. 
- Queue Outflow (per minutes) : Number user to be allowed to ENTER site. Estimation based on : load test result , bandwidth, How long a typical user stay in the site. 
- Can request Load test timeslot from QIT, to avoid trigger security measure. 

### IT-Product : WAF F5 
- Feature : Security Policy, Traffic Learning , block suspicious requests and attacks 
- Bot Defense ( With URL whitelist)
- IP Whitelisting / blacklisting 
- Traffic Monitoring 
- As load balancer, with HealthCheck to downstream nodes
- SSL Termination


## Software Engineering

### SDLC (Software Development Life Cycle)
 
- Waterfall Model: Requirements,Req. Analysis,Design,Implementation,Testing,Deployment,Maintenance
- Iterative Waterfall Model e.g. R->RA->D->I->T->D->I->T->D->I->T. .. Code, get feedback, Code.
- Iterative : Better adapting to change in Req./Technology, higher cost.
- Agile : ????


### Specification Documents
 
1. Requirement Spec  
- What the application should do ?
- Read by Manager, Client, Users
- In business sense, what the system do to achieve business goal. What are those business rules from users's perspective ?

2. Functional Spec (Sometimes called System Spec.)
- How the application function ? 
- Read by Tester, Maintainer, System Analyst.

3. Program Spec 
- How to Implement ?
- Pesudo Code. 
- Ready by Programmer

4. Thoughts : 
- RS and FS should be describing the same thing. Just that FS is more system component/flow oriented while RS is more business oriented. 


### Commonly used design diagrams  
- UML Use Case Digram 
- UML Class Diagram 
- UML Sequence Diagram 
- Flow chart ( not UML ), UML Activity is complex verion of Flow chart 

### Class diagram -- Relationship 
- Dependency   ---------> (Too vague , not commonly used ).
- Association  _________ , Example Teacher teaches students,   
- Aggregration ________<> , describe "HAS A" relationship   e.g. Car <>________ Passenger
- Composition  ________<B> , describe "OWN A" relationship, e.g. Dog <B>______ Tail    
- Inheritence _________|> , describe "IS A" relationship , e.g. Bank Account <|_______ Saving Account 
- Realization ---------|S>  

- Aggregation vs Composition : Compo -- parts cannot exist alone, the main controls the lifetime(existence) of the part.While not so for Agg. 
- Aggregation vs Association : You can say Teacher "HAS A" Student. Just that association does not make clear. Aggregation is special case of Association.
- All relations bolt down to "What you think about the system" 

### Testing 
- Integration Test 
- Unit Test 
- Regression Test 
- Black Box Test vs Transparent Test 