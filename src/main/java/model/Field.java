package model;


public class Field {
    private int fieldID;        // ID của sân nhỏ
    private int stadiumID;      // ID của sân lớn mà sân nhỏ thuộc về
    private String fieldName;   // Tên sân nhỏ (ví dụ: "Sân 5 người A1")
    private String type;        // Loại sân (ví dụ: "5 người", "7 người")
    private String description; // Mô tả chi tiết về sân nhỏ

    // Constructor mặc định
    public Field() {
    }

    // Constructor đầy đủ tham số
    public Field(int fieldID, int stadiumID, String fieldName, String type, String description) {
        this.fieldID = fieldID;
        this.stadiumID = stadiumID;
        this.fieldName = fieldName;
        this.type = type;
        this.description = description;
    }

    // Getter và Setter cho fieldID
    public int getFieldID() {
        return fieldID;
    }

    public void setFieldID(int fieldID) {
        this.fieldID = fieldID;
    }

    // Getter và Setter cho stadiumID
    public int getStadiumID() {
        return stadiumID;
    }

    public void setStadiumID(int stadiumID) {
        this.stadiumID = stadiumID;
    }

    // Getter và Setter cho fieldName
    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    // Getter và Setter cho type
    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    // Getter và Setter cho description
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}