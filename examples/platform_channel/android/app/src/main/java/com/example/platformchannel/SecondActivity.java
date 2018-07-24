package com.example.platformchannel;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import org.w3c.dom.Text;

public class SecondActivity extends Activity {

    public TextView mViewName;

    public Button mBtnChange;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_second);

        mViewName = findViewById(R.id.textView);
        mBtnChange = findViewById(R.id.button);

        Intent intent = getIntent();

        TransData data = intent.getParcelableExtra("data");

        if (null != data) {
            mViewName.setText(data.getName());
        }

        mBtnChange.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mViewName.setText("native page text");
            }
        });
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();

        TransData data = new TransData();
        data.setName(mViewName.getText() + "");

        Intent intent = new Intent();
        intent.putExtra("data", data);

//        setResult(Activity.RESULT_OK, intent);

        intent.setClass(this, MainActivity.class);
        startActivity(intent);

        finish();
    }

    // prev page onActivityResult before onDestroy
    @Override
    protected void onDestroy() {
        super.onDestroy();

    }
}
