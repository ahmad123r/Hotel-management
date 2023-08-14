package com.example.hotel_management_application.activities;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.RequiresApi;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.example.hotel_management_application.R;
import com.example.hotel_management_application.encryption.SymmtCrypto;
import com.example.hotel_management_application.userapi.UserUploadData;
import com.example.hotel_management_application.userapi.UserViewMessage;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;


import java.sql.Timestamp;
import java.util.Objects;

public class RegisterActivity extends AppCompatActivity implements UserViewMessage {
    EditText edName, edEmail, edPassword;
    UserUploadData uploadUserRecord;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Objects.requireNonNull(getSupportActionBar()).hide(); //This Line hides the action bar
        setContentView(R.layout.activity_register_page);

        edName = findViewById(R.id.text_name);
        edEmail = findViewById(R.id.text_email);
        edPassword = findViewById(R.id.password);

        uploadUserRecord = new UserUploadData(this);

    }

    private void validation() {
        String Name = edName.getText().toString().trim();
        String Email = edEmail.getText().toString().trim();
        String Password = edPassword.getText().toString().trim();

        if (!TextUtils.isEmpty(Name)
                && !TextUtils.isEmpty(Password)
                && !TextUtils.isEmpty(Email)) {
            //send info

            RegisterWithEmailAndPassword(Name, Email, Password);

        } else {
            if (TextUtils.isEmpty(Name)) {
                edName.setError("Name is required");
                return;
            }
            if (TextUtils.isEmpty(Email)) {
                edEmail.setError("Email is required");
                return;
            }
            if (TextUtils.isEmpty(Password)) {
                edPassword.setError("password is required");
            }


        }
    }

    private void RegisterWithEmailAndPassword(String name, String email, String password) {
        FirebaseAuth auth = FirebaseAuth.getInstance();
        auth.createUserWithEmailAndPassword(email, password)
                .addOnSuccessListener(new OnSuccessListener<AuthResult>() {
                    @RequiresApi(api = Build.VERSION_CODES.O)
                    @Override
                    public void onSuccess(AuthResult authResult) {
                        FirebaseUser user = auth.getCurrentUser();
                        if (user != null) {
                            user.sendEmailVerification().addOnSuccessListener(new OnSuccessListener<Void>() {
                                @Override
                                public void onSuccess(Void unused) {
                                    SymmtCrypto symmtCrypto = new SymmtCrypto();
                                    try {

                                        uploadUserRecord.onSuccessUpdate(RegisterActivity.this, symmtCrypto.encrypt(name), email, symmtCrypto.encrypt(password));
                                        //send verification email
                                        //call verify ui
                                        Toast.makeText(RegisterActivity.this, "Verification email has been sent !", Toast.LENGTH_LONG).show();
                                        Intent intent = new Intent(RegisterActivity.this, VerifyEmailActivity.class);
                                        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                                        startActivity(intent);
                                        finish();

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                        Toast.makeText(RegisterActivity.this, e.getMessage(), Toast.LENGTH_LONG).show();

                                    }
                                }
                            }).addOnFailureListener(new OnFailureListener() {
                                @Override
                                public void onFailure(@NonNull Exception e) {
                                    Toast.makeText(RegisterActivity.this, "Try again later !", Toast.LENGTH_LONG).show();
                                }
                            });
                        }
                    }
                })
                .addOnFailureListener(new OnFailureListener() {
                    @Override
                    public void onFailure(@NonNull Exception e) {
                        Toast.makeText(RegisterActivity.this, e.getMessage(), Toast.LENGTH_LONG).show();

                    }
                });
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Intent intent = new Intent(RegisterActivity.this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
        finish();
    }

    public void onRegisterActivity(View view) {
        validation();
    }

    public void onLoginActivity(View view) {
        Intent intent = new Intent(RegisterActivity.this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
        finish();
    }

    @Override
    public void onUpdateSuccess(String message) {
        Toast.makeText(RegisterActivity.this, message, Toast.LENGTH_LONG).show();
    }

    @Override
    public void onUpdateFailure(String message) {
        Toast.makeText(RegisterActivity.this, message, Toast.LENGTH_LONG).show();
    }
}