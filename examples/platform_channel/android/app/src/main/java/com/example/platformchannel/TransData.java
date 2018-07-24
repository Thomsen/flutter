package com.example.platformchannel;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.HashMap;
import java.util.Map;

public class TransData implements Parcelable {

    private String name;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.name);
    }

    public void fromMap(Map<String, Object> map) {
        if (null != map) {
            if (map.get("name") instanceof String) {
                name = (String) map.get("name");
            }
        }
    }

    public HashMap<String, Object> toMap() {
        HashMap<String, Object> map = new HashMap<>();

        map.put("name", this.name);

        return map;
    }

    public TransData() {
    }

    protected TransData(Parcel in) {
        this.name = in.readString();
    }

    public static final Parcelable.Creator<TransData> CREATOR = new Parcelable.Creator<TransData>() {
        @Override
        public TransData createFromParcel(Parcel source) {
            return new TransData(source);
        }

        @Override
        public TransData[] newArray(int size) {
            return new TransData[size];
        }
    };
}
