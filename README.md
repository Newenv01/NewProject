# NewProject
NewProj
testing


TEsting

 - name: hosts
   hosts: all

  - name: Target Host
    file:
       path: /etc/ansible/facts.d
       state: directory
       recurse: yes
  - name: Test File Copy
    copy:
       src: /etc/ansible/facts.d/getdate1.sh
       dest: /etc/ansible/facts.d/getdate2.sh
       mode: 0755
  - name:
    copy:
       src: /etc/ansible/facts.d/getdate2.sh
       dest: /etc/ansible/facts.d/getdate2.sh
       mode: 0755

  - name: default
    setup:

 - name: Test files
   debug:
      msg: "{{ ansible_default_ipv4.address }}"

 - name: Test files
   debug:
      msg: "{{ ansible_local.get.fdate1 }}"

 - name: Test files
   debug:
      msg: "{{ ansible_local.get.fdate2 }}"

 - name: Test files
   debug:
      msg: "{{ hostvars[ansible_hostname].ansible_local.get.fdate1 }}"

 - name: Test files
   debug:
      msg: "{{ hostvars[ansible_hostname].ansible_local.get.fdate2 }}"



Jinja2 -=-==-=-

   hosts: all

   tasks:
    debug:
       msg: >
                -= testing -=
             {# TESTING -#}
             {% if ansible_hostname == "ubuntu-c" -%}
                    This is UNBUNTU-C Server
             {% elif ansible_hostname == "redhad" -%}
		    This is Redjhad
	     {% else -%}
                    This is old 
             {% endif %}

             {% set varible_xx = "test" -%}
             {% if variable_xx is defined -%}
                 variable_xx is defind
             {% else -%}
                 variable_xx is not defind
             {% endif %}

             {% for entry in ansible_ip4address_entry %}
                  IP ADDRESS ENTRY {{ loop.index }} = {{ entry }}
             {% endfor %}

  {% for YY in range(10, 0, -1) -%}
      {% if YY == "5" -%}
          {% break %}
      {% endif -%}
      {{ entry }}
  {% endfor %}


- name : test
  hosts: all

- name: test loop
  tasks:
       template:
               src: /tmp/path/template.txt
               dest: {{ ansible_hostname }}_template.out
               state: true                


 hosts: ubuntu01, ubunto02
    
 tasks:
      yum: 
         name: epel-release
         update_cache: yes
         state: latest
         update:
      when: ansible_distribution == "ubunto01"

      yum:
         name: nginx
         update_cache: yes
         state: latest
     when: ansible_distribution == "ubunto02"
