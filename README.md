
# 📈 SQL Sales Data Analysis Project

This project showcases SQL-based data analysis using **PostgreSQL 17** on a sample **Sales dataset** containing `Orders` and `Customers` information. It focuses on querying relational data, performing aggregations, and gaining business insights from raw datasets.The aim is to extract meaningful insights from the data using various SQL queries involving filtering, aggregation, joins, sorting, and grouping.

---

 📁 Project Structure

```
SQL-Sales-Analysis-Project/
│
├── data/
│   ├── orders.csv           # Sample Orders dataset
│   └── customers.csv        # Sample Customers dataset
│
├── queries/
│   └── analysis_queries.sql # SQL queries for data exploration and insights
│
├── screenshots/
│   └── sample_output.png    # (Optional) Screenshot of SQL results or Tableau viz
│
└── README.md                # Project documentation
```

---

💠 Tools & Technologies

* **PostgreSQL 17**
* **pgAdmin**
* (Optional) **Tableau** or **Excel** for visualization

---

🔍 Key SQL Concepts Used

* `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`
* `JOIN` (INNER JOIN, LEFT JOIN)
* Aggregate functions: `SUM()`, `COUNT()`, `AVG()`, `MAX()`, `MIN()`
* `LIMIT`, `IN`, `BETWEEN`
* Data filtering and conditional logic

---

 📌  Insights Derived

* Top 10 orders with the highest discount
* Orders with discount greater than zero
* Sales between specific ranges (e.g., ₹100 and ₹500)
* Unique cities from northern and eastern regions
* Sales grouped by product category (e.g., Beverages)
* Customer data enriched with region and order information

---

🚀 Getting Started

1. **Clone the repository:**

   ```bash
   git clone https://github.com/your-username/SQL-Sales-Analysis-Project.git
   ```

2. **Set up PostgreSQL and pgAdmin**

3. **Import the CSV data into your PostgreSQL database:** Use `COPY` or `\COPY` command, or upload via pgAdmin.

4. **Run SQL queries:** Execute the queries in `queries/analysis_queries.sql` file using pgAdmin or any SQL editor.

---

 📈 Optional: Visualization

Use tools like **Tableau** or **Power BI** to visualize query outputs such as:

* Sales trend by region
* Top customers by discount received
* Product category-wise revenue

---



## 📬 Contact

**Kajal Dhuria**
Email: [kajalldhuria97@gmail.com](mailto:kajalldhuria97@gmail.com)
LinkedIn: [linkedin.com/in/kajalldhuria](https://linkedin.com/in/kajalldhuria)

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).
