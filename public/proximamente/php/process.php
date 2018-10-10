<?php


    if ($_SERVER["REQUEST_METHOD"] == "POST") {
  
        $name = strip_tags(trim($_POST["name"]));
				$name = str_replace(array("\r","\n"),array(" "," "),$name);
        $email = filter_var(trim($_POST["email"]), FILTER_SANITIZE_EMAIL);
        $message = trim($_POST["message"]);

     
        if ( empty($name) OR empty($message) OR !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            
			header("HTTP/1.1 400 Bad Request");
            echo "Oops! Tuvimos un problema por favor vuelve a intentarlo";
            exit;
        }

        
        // Update this to your desired email address.
        $recipient = "7leonr@gmail.com";

        // Set the email subject.
        $subject = "New contact from $name";


        $email_content = "Name: $name\n";
        $email_content .= "Email: $email\n\n";
        $email_content .= "Message:\n$message\n";

     
        $email_headers = "From: $name <$email>";

    
        if (mail($recipient, $subject, $email_content, $email_headers)) {
           
            
			header("HTTP/1.1 200 OK");
            echo "¡Gracias! Tu mensaje ha sido enviado.";
        } else {
            
            
			header("HTTP/1.0 500 Internal Server Error");
            echo "Oops! Tuvimos un problema por favor vuelve a intentarlo";
        }

    } else {
       
        
		header("HTTP/1.1 403 Forbidden");
        echo "Oops! Tuvimos un problema por favor vuelve a intentarlo";
    }

?>