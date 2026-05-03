import os

from dotenv import load_dotenv
from openai import OpenAI


class LLMClient:
    def __init__(self):
        load_dotenv()
        self.api_key = os.getenv("LLM_API_KEY")
        self.base_url = os.getenv("LLM_BASE_URL")
        self.model = os.getenv("LLM_MODEL")

        if not all([self.api_key, self.base_url, self.model]):
            raise ValueError(
                "Missing environment variables: LLM_API_KEY, LLM_BASE_URL, LLM_MODEL"
            )

        self.client = OpenAI(api_key=self.api_key, base_url=self.base_url)

    def generate_sql(self, dbms, schema):
        prompt = f"Generate a single SQL fuzzing query for {dbms}. Schema: {schema}. The query should have approximately 35 unique tokens on average."

        try:
            response = self.client.chat.completions.create(
                model=self.model,
                messages=[
                    {
                        "role": "system",
                        "content": "You are a SQL generation assistant.",
                    },
                    {"role": "user", "content": prompt},
                ],
            )
            raw_sql = response.choices[0].message.content.strip()

            if "```sql" in raw_sql:
                sql_query = raw_sql.split("```sql")[1].split("```")[0].strip()
            elif "```" in raw_sql:
                sql_query = raw_sql.split("```")[1].strip()
            else:
                sql_query = raw_sql

            usage = response.usage
            return sql_query, raw_sql, usage.prompt_tokens, usage.completion_tokens
        except Exception as e:
            print(f"Error generating SQL: {e}")
            return None, None, 0, 0
