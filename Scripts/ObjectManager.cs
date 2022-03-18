using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectManager : MonoBehaviour
{
    [SerializeField] GameObject[] rotateObjects;
    [SerializeField] GameObject[] moveObjects;
    public float speed;

    void Start()
    {
        
    }

    void Update()
    {
        foreach (GameObject go in rotateObjects)
        {
            go.transform.Rotate(Vector3.right * 0.2f);
        }
        foreach (GameObject go in moveObjects)
        {
            float y = Mathf.PingPong(Time.time * speed, 1) * 2 - 1;
            go.transform.position = new Vector3(3.5f, y, 0);
        }
    }
}
