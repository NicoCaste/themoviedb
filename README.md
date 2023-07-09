# themoviedb

Hi! I hope you enjoy the project as I did programming it.
Remember that in order to test the code you must create an account [in this link](
https://developer.themoviedb.org/reference/intro/authentication)
after that they should go to the class **_TheMovieRepository_**
and in the static variable key enter your apikey as a string.
<img width="535" alt="image" src="https://github.com/NicoCaste/themoviedb/assets/56919623/32905c02-c255-40c5-b562-6a538ece1e5b">


The architecture is based on MVVM oriented to protocols.
The flow of the application is very simple, I leave some screen prints of what you will find.

At the time of development, the ease of **reusing views** and building them was taken as the main theme, and on the part of the user, the fluides and the preloading of the views to have the least possible lag.
You will find a UIView with a generic tableView which pre-implements all the basics that a tableview should do with the help of a protocol of the basicViewModel type that is injected into the constructor and simplifies the implementation of this view.
For specific handling cases you can use the view delegate protocol with optional methods to subscribe to.
<img width="369" alt="image" src="https://github.com/NicoCaste/themoviedb/assets/56919623/e8f490b7-7111-4347-8a4f-a5691d0dc388">
<img width="355" alt="image" src="https://github.com/NicoCaste/themoviedb/assets/56919623/f593bfe6-d286-448b-a34b-e6219c79ffb3">
<img width="349" alt="image" src="https://github.com/NicoCaste/themoviedb/assets/56919623/c834ea64-50e6-46a6-bef2-7effe9484fec">
<img width="366" alt="image" src="https://github.com/NicoCaste/themoviedb/assets/56919623/44267b43-9665-43aa-ab30-dacdc6eb8e12">



