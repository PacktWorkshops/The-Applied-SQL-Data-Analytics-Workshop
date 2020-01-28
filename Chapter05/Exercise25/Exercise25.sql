-- Explode out each sale into its own row. We can do this using the JSONB_ARRAY_ELEMENTS function, which does exactly that:

CREATE TEMP TABLE customer_sales_single_sale_json AS (
    SELECT
        customer_json,
        JSONB_ARRAY_ELEMENTS(customer_json -> 'sales') AS sale_json
    FROM customer_sales LIMIT 10
);

-- Next, we can simply filter this output, and grab the records where the product_name is 'Blade':

SELECT DISTINCT customer_json FROM customer_sales_single_sale_json WHERE sale_json ->> 'product_name' = 'Blade' ;


-- make the result easier to read by using JSONB_PRETTY() to format the output:

SELECT DISTINCT JSONB_PRETTY(customer_json) FROM customer_sales_single_sale_json WHERE sale_json ->> 'product_name' = 'Blade' ;

-- We can also perform this same action with JSON path expressions:

CREATE TEMP TABLE blade_customer_sales AS (
  SELECT
    jsonb_path_query(
      customer_json,
      '$ ? (@.sales[*].product_name == "Blade")'
    ) AS customer_json
  FROM customer_sales
);

SELECT JSONB_PRETTY(customer_json) FROM blade_customer_sales;

-- finally, to get the count:

SELECT COUNT(1) FROM blade_customer_sales;
